
  //画像ファイルプレビュー表示のイベント追加 fileを選択時に発火するイベントを登録
  $("#image").change(function(e) {
    var file = e.target.files[0],
        reader = new FileReader(),
        $preview = $(".preview");

    // 画像ファイル以外の場合は何もしない
    if(file.type.indexOf("image") < 0){
      return false;
    }

    // ファイル読み込みが完了した際のイベント登録
    reader.onload = (function(file) {
      return function(e) {
        //既存のプレビューを削除
        $preview.empty();
        // .prevewの領域の中にロードした画像を表示するimageタグを追加
        $preview.append($('<img>').attr({
                  src: e.target.result,
                  id: "crop_img",
                  title: file.name
              }));
              $('#crop_img').cropper({
                });
              };
    })(file);

    reader.readAsDataURL(file);
  });

  $('#_submit').on('click', function(){
   // crop のデータを取得
   var canvas = $('#crop_img').cropper('getCroppedCanvas');
   var canvas_data = canvas.toDataURL();
   $("#post_image_name").val(""); //画像データを二重に送信するのを防ぐ
   $("#post_remote_image_url").val(canvas_data);
   $("#myform").submit();
});
