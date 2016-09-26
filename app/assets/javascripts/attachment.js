function attach_document(token, message) {
  var path, uploadAttachment, authenticity_token;

  document.addEventListener("trix-file-accept", function(event) {
    if (message) {
      alert(message);
      event.preventDefault();
      return fal;
    } else
      return true;
  });
  

  document.addEventListener("trix-attachment-add", function(event) {
    var attachment;
    attachment = event.attachment;
    if (attachment.file) {
      return uploadAttachment(attachment);
    }
  });

  document.addEventListener("trix-attachment-remove", function(event) {
    var attachment;
    attachment = event.attachment;
    return removeAttachment(attachment);
  });
  
  
  path = "attachments";

  uploadAttachment = function(attachment) {
    var file, form, xhr;
    file = attachment.file;
    form = new FormData;
    form.append("Content-Type", file.type);
    form.append("authenticity_token", token);
    form.append("attachment[doc]", file);
    xhr = new XMLHttpRequest;
    xhr.open("POST", path, true);
    xhr.upload.onprogress = function(event) {
      var progress;
      progress = event.loaded / event.total * 100;
      return attachment.setUploadProgress(progress);
    };
    xhr.onload = function() {
      var response, doc_id, href, url;
      if (xhr.status === 200) {
        response = JSON.parse(xhr.responseText);
        doc_id = response.id
        filename = response.doc_file_name
        url = "/system/attachments/docs/"+doc_id+"/medium/"+filename;
        href = "/system/attachments/docs/"+doc_id+"/original/"+filename;
        return attachment.setAttributes({
          url: url,
          href: href,
          doc_id: doc_id
        });
      }
    };
    return xhr.send(form);
  };

  removeAttachment = function(n) {
    var doc_id, xhr, form;
    form = new FormData;
    form.append("authenticity_token", token);
    doc_id = n.attachment.attributes.values.doc_id;
    xhr = new XMLHttpRequest;
    xhr.open("DELETE", path+"/"+doc_id, true);
    return xhr.send(form);
  };
  
  createStorageKey = function(file) {
    var date, day, time;
    date = new Date();
    day = date.toISOString().slice(0, 10);
    time = date.getTime();
    return "tmp/" + day + "/" + time + "-" + file.name;
  };

};
