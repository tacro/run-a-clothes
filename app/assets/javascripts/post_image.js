$(function() {
  $('.directUpload').find("input:file").each(function(i, elem) {
    var fileInput    = $(elem);
    var form         = $(fileInput.parents('form:first'));
    var submitButton = form.find('input[type="submit"]');
    var progressBar  = $("<div class='bar'></div>");
    var barContainer = $("<div class='progress'></div>").append(progressBar);
    fileInput.after(barContainer);
    fileInput.fileupload({
    fileInput:       fileInput,
    url:             form.data('url'),
    type:            'POST',
    autoUpload:       false,
    formData:         form.data('form-data'),
    paramName:        'file', // S3 does not like nested name fields i.e. name="user[avatar_url]"
    dataType:         'XML',  // S3 returns XML if success_action_status is set to 201
    replaceFileInput: false,
    acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,

    add: function(e, data){
      if (data.files && data.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
          $('.preview').empty();
          $('.preview').append($('<img>').attr({// insert preview image
            src: e.target.result,
            id: "crop_img",
            title: data.files[0].name
          }));
          $('#crop_img').cropper() // initialize cropper on preview image
         };
       reader.readAsDataURL(data.files[0]);
      };

      submitButton.on('click', function(){
      $('form').submit(function(){
        return false;
        });
       // crop のデータを取得
       $('#crop_img').cropper('getCroppedCanvas').toBlob(function (blob){
          data.files[0] = new File([blob], data.files[0].name);
          data.originalFiles[0] = data.files[0];
          data.submit();
        })
     });
    },

    progressall: function (e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      progressBar.css('width', progress + '%')
    },

    start: function (e) {
      submitButton.prop('disabled', true);

      progressBar.
        css('background', 'black').
        css('display', 'block').
        css('width', '0%').
        text("Loading...");
    },

    done: function(e, data) {
      submitButton.prop('disabled', false);
      progressBar.text("Uploading done");

      // extract key and generate URL from response
      var key   = $(data.jqXHR.responseXML).find("Key").text();
      var url   = '//' + form.data('host') + '/' + key;

      // create hidden field
      var input = $("<input />", { type:'hidden', name: fileInput.attr('name'), value: url })
      form.append(input);

      //delete submit event which is false
      $('form').off('submit');
      //and submit again
      $('.directUpload').submit();
    },

    fail: function(e, data) {
      submitButton.prop('disabled', false);

      progressBar.
        css("background", "red").
        text("Failed");
      }
    });
  });
});
