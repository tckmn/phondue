(function() {
    var inputBox, oldVal = '';
    var keypress = function(e) {
        var val = inputBox.value;
        if (val.length > oldVal.length) {
            // for browsers that don't support selectionStart, too bad,
            //   digraphs only work at the end
            var pos = inputBox.selectionStart || val.length;
            var digraph = digraphs[val.substr(pos - 2, 2)];
            if (digraph) {
                val = val.slice(0, pos - 2) + digraph + val.slice(pos);
                inputBox.value = val;
            }
        }
        oldVal = val;
    };

    var digraphs = {};

    window.addEventListener('load', function() {
        var builderReq = new XMLHttpRequest();
        builderReq.addEventListener('load', function() {
            document.body.innerHTML = this.responseText;
            [].slice.call(document.getElementsByTagName('button'))
                    .forEach(function(btn) {
                btn.addEventListener('click', function() {
                    oldVal = inputBox.value += btn.innerText;
                    inputBox.focus();
                });
            });

            inputBox = document.createElement('input');
            inputBox.id = 'inputBox';
            inputBox.spellcheck = false;
            inputBox.addEventListener('keyup', keypress);
            document.body.appendChild(inputBox);
        });
        builderReq.open('GET', 'builder.html');
        builderReq.send();

        var digraphsReq = new XMLHttpRequest();
        digraphsReq.addEventListener('load', function() {
            this.responseText.split('\n').forEach(function(digraph) {
                var chunks = digraph.match(/\S{8}/g);
                // failsafe
                if (!chunks || chunks.length != 3) return;
                chunks = chunks.map(function(hex) {
                    return String.fromCharCode(parseInt(hex, 16));
                });
                digraphs[chunks[0] + chunks[1]] = chunks[2];
            });
        });
        digraphsReq.open('GET', 'digraphs.txt');
        digraphsReq.send();
    });
})();
