#include <gtk/gtk.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

typedef struct {
    uint64_t code;
    gunichar replacement;
} Digraph;
static Digraph *digraphs;
#define DIGRAPH_BUF_STEP 100

static GtkEntry *input;

static void apply_css(GtkWidget *widget, GtkStyleProvider *provider) {
    gtk_style_context_add_provider(gtk_widget_get_style_context(widget),
            provider, G_MAXUINT);
    if (GTK_IS_CONTAINER(widget)) {
        gtk_container_forall(GTK_CONTAINER(widget), (GtkCallback)apply_css,
                provider);
    }
}

static void keypress(GtkEntry *input, gpointer user_data) {
    const gchar *text = gtk_entry_get_text(input);
    gint cursor = gtk_editable_get_position(GTK_EDITABLE(input));

    // parse letter combinations
    if (cursor > 0) {
        // find the two Unicode chars before the cursor
        gchar *textPos = g_utf8_offset_to_pointer(text, cursor - 1);
        gunichar ch1 = g_utf8_get_char(textPos);
        textPos = g_utf8_next_char(textPos);
        gunichar ch2 = g_utf8_get_char(textPos);
        textPos = g_utf8_next_char(textPos);

        // encode in a consistent format
        uint64_t code = ((uint64_t)(ch1) << 32) | ch2;

        gunichar replacement = 0;

        // test with a few special cases and then the digraphs array
        if (ch1 == '\\') {
            replacement = ch2;
        } else {
            for (Digraph *d = digraphs;; ++d) {
                if (code == d->code) {
                    replacement = d->replacement;
                    break;
                } else if (code < d->code) break;
            }
        }

        if (replacement) {
            int textLen = strlen(text);

            // just to be safe, let's add a little buffer...
            gchar *newText = malloc((textLen + 10) * sizeof(gchar));
            g_utf8_strncpy(newText, text, cursor - 1);
            gchar *newTextPos = g_utf8_offset_to_pointer(newText, cursor - 1);
            newTextPos += g_unichar_to_utf8(replacement, newTextPos);
            g_utf8_strncpy(newTextPos, textPos, textLen - cursor - 1);

            gtk_entry_set_text(input, newText);
        }
    }
}

static void buttonclick(GtkButton *button, gpointer user_data) {
    const gchar *text = gtk_entry_get_text(input);
    int textLen = strlen(text);
    // again, some buffer just to be safe...
    char *newText = malloc((textLen + 10) * sizeof(gchar));
    strcpy(newText, text);
    strcpy(newText + textLen, gtk_button_get_label(button));
    gtk_entry_set_text(input, newText);
    gtk_entry_grab_focus_without_selecting(input);
}

int main(int argc, char **argv) {
    gtk_init(&argc, &argv);

    // load digraph information from file
    int digraphsBufLen = DIGRAPH_BUF_STEP, digraphsIdx = 0;
    digraphs = malloc((digraphsBufLen + 1) * sizeof(Digraph));

    FILE *dgfp = fopen("src/digraphs.txt", "r");

    uint64_t code;
    gunichar replacement;
    while (fscanf(dgfp, "%lx %x\n", &code, &replacement) != EOF) {
        digraphs[digraphsIdx++] = (Digraph) { code, replacement };
        if (digraphsIdx > digraphsBufLen) {
            digraphsBufLen += DIGRAPH_BUF_STEP;
            digraphs = realloc(digraphs, (digraphsBufLen + 1) * sizeof(Digraph));
        }
    }
    digraphs[digraphsIdx] = (Digraph) { -1, 0 };

    fclose(dgfp);

    // read UI information from file
    GtkBuilder *builder = gtk_builder_new();
    gtk_builder_add_from_file(builder, "src/builder.ui", NULL);
    GObject *win = gtk_builder_get_object(builder, "window");

    // read style information from file
    GtkCssProvider *provider = gtk_css_provider_new();
    gtk_css_provider_load_from_path(provider, "src/builder.css", NULL);
    apply_css(GTK_WIDGET(win), GTK_STYLE_PROVIDER(provider));

    // exit properly when window is closed
    g_signal_connect(win, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    // attach to "key pressed" signal
    input = GTK_ENTRY(gtk_builder_get_object(builder, "input"));
    g_signal_connect(input, "changed", G_CALLBACK(keypress), NULL);

    // attach to "button clicked" signals
    GSList *allObjects = gtk_builder_get_objects(builder), *cursor = allObjects;
    while (cursor != NULL) {
        GObject *obj = (GObject*)cursor->data;
        if (!strcmp("GtkButton", G_OBJECT_TYPE_NAME(obj))) {
            g_signal_connect(obj, "clicked", G_CALLBACK(buttonclick), NULL);
        }
        cursor = cursor->next;
    }
    g_slist_free(allObjects);

    gtk_main();

    return 0;
}
