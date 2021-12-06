$(function(){
    $(".container").fadeIn(1000);
    $(".container").draggable();
    let loading = true;
    let loaded = false;

    setTimeout(function(){
        window.addEventListener('message', function(event){
            let data = event.data
            if (data.action == 'setFps'){
                if (loading){
                    if (!loaded){
                        loaded = true;
                        $('.text').fadeOut(400)
                        setTimeout(function(){
                            $('.text').html('FPS: ' + data.fps)
                            $('.text').fadeIn(400)
                            setTimeout(function(){
                                loading = false;
                            }, 400);
                        }, 400);
                    };
                }else{
                    $('.text').html('FPS: ' + data.fps)
                };
            };
        });
    }, 500);

    document.onkeyup = function (event) {
        if (event.key == 'Escape') {
            $.post('https://j-fps/close', JSON.stringify({}));
        };
    };
});