$(function(){
    $(".fpsbox").draggable();
    let virgen = true;
    let hecho = false;

    setTimeout(function(){
        window.addEventListener('message', function(event){
            let data = event.data
            if (data.action == 'setFps'){
                if (virgen){
                    if (!hecho){
                        hecho = true;
                        $('.text').fadeOut(400)
                        setTimeout(function(){
                            $('.text').html('FPS: ' + data.fps)
                            $('.text').fadeIn(400)
                            setTimeout(function(){
                                virgen = false;
                            }, 400);
                        }, 400);
                    };
                }else{
                    $('.text').html('FPS: ' + data.fps)
                };
            };
        });
    }, 3400);

    document.onkeyup = function (event) {
        if (event.key == 'Escape') {
            $.post('https://c-fps/close', JSON.stringify({}));
        };
    };
});
