(function() {
    var inputBox;
    var keypress = function(e) {
        var val = inputBox.value,
            key = String.fromCharCode(e.which || e.keyCode),
            pos = inputBox.selectionStart || val.length,
            digraph = digraphs[val.substr(pos - 1, 1) + key];
        if (digraph) {
            e.preventDefault();
            val = val.slice(0, pos - 1) + digraph + val.slice(pos);
            inputBox.value = val;
        }
    };

    var digraphs = {};

    window.addEventListener('load', function() {
        var builderReq = new XMLHttpRequest();
        builderReq.addEventListener('load', function() {
            document.body.innerHTML = this.responseText;
            [].slice.call(document.getElementsByTagName('button'))
                    .forEach(function(btn) {
                btn.addEventListener('click', function() {
                    inputBox.value += btn.innerText;
                    inputBox.focus();
                });
            });

            inputBox = document.createElement('input');
            inputBox.id = 'inputBox';
            inputBox.spellcheck = false;
            inputBox.addEventListener('keypress', keypress);
            document.body.appendChild(inputBox);
        });
        builderReq.open('GET', 'builder.html');
        builderReq.send();

        var digraphsReq = new XMLHttpRequest();
        digraphsReq.addEventListener('load', function() {
            this.responseText.split('\n').forEach(function(digraph) {
                var chunks = digraph.match(/\S{8}/g);
                if (!chunks || chunks.length != 3) return;  // failsafe
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
