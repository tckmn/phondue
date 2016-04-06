#include <gtk/gtk.h>

static void activate(GtkApplication* app, gpointer user_data) {
    // create main window
    GtkWidget *win = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(win), "Phondue");
    gtk_container_set_border_width(GTK_CONTAINER(win), 10);

    // the grid that's used for layout of all the widgets
    GtkWidget *grid = gtk_grid_new();
    gtk_container_add(GTK_CONTAINER(win), grid);

    gtk_widget_show_all(win);
}

int main(int argc, char **argv) {
    // startup
    GtkApplication *app = gtk_application_new("com.keyboardfire.phondue",
            G_APPLICATION_FLAGS_NONE);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);

    // run
    int status = g_application_run(G_APPLICATION(app), argc, argv);

    // cleanup
    g_object_unref(app);
    return status;
}
