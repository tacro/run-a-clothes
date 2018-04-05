$(function() {
  $('.directUpload').find("input:file").each(function(i, elem) {
    var fileInput    = $(elem);
    var form         = $(fileInput.parents('form:first'));
    var submitButton = form.find('input[type="submit"]');
    var progressBar  = $("<div class='bar'></div>");
    var barContainer = $("<div class='progress'></div>").append(progressBar);
    fileInput.after(barContainer);

    // var lastData = null;

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
      // singleFileUploads: false,
      maxNumberOfFiles: 1,
      sequentialUploads: true,
      limitMultiFileUploads:1,
      limitConcurrentUploads: 1,

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
         // $('#clear').show();
        };
        submitButton.on('click', function(e){
          e.preventDefault();
         // crop のデータを取得
         $('#crop_img').cropper('getCroppedCanvas').toBlob(function (blob){
            data.files[0] = new File([blob], data.files[0].name);
            data.originalFiles[0] = data.files[0];
            // at this point the data is correct on both browsers
            data.submit();
          })
        //  var canvas = $('#crop_img').cropper('getCroppedCanvas');
        //  var canvas_data = canvas.toDataURL();
        //  var blobData = dataURItoBlob(canvas_data);
        //  function dataURItoBlob(dataURI) {
        //     var binary = atob(dataURI.split(',')[1]);
        //     var array = [];
        //     for(var i = 0; i < binary.length; i++) {
        //         array.push(binary.charCodeAt(i));
        //     }
        //     return new Blob([new Uint8Array(array)], {type: 'image/jpeg'});
        // }
        // lastData.files[0] = new File([blobData], lastData.files[0].name);
        // lastData.originalFiles[0] = lastData.files[0];
        // lastData.submit();
        });


        // lastData = data;
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
          text("Upload Failed!");
        }
      });
  });
});
