
  //画像ファイルプレビュー表示のイベント追加 fileを選択時に発火するイベントを登録
  $("#upload").change(function(e) {
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
    // alert("clecked!");
    // var _form = $("#create_posts");
   // crop のデータを取得
   var data = $('#crop_img').cropper('getData');
  // console.error("error in click");
  console.log(data.x);
  $("#post_image_x").val(Math.round(data.x));
  $("#post_image_y").val(Math.round(data.y));
  $("#post_image_w").val(Math.round(data.width));
  $("#post_image_h").val(Math.round(data.height));

   // $("#post_image_name").val(""); //画像データを二重に送信するのを防ぐ
   // $("#post_remote_image_url").val(data);
   // $("create_posts").submit();
   // _form.submit();
   $("#myform").submit();
   alert("submitted!");

});
