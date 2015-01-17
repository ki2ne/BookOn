$(document).ready(function() {
    $('.register_form').bootstrapValidator({
        live: 'disabled',
        message: 'This value is not valid',
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            register_id: {
                message: 'ID is not valid',
                validators: {
                    notEmpty: {
                        message: 'IDを入力してください   (例: 1012)'
                    },
                    stringLength: {
                        min: 4,
                        max: 4,
                        message: '有効なIDを入力してください'
                    },
                    integer: {
                        message: '半角数字で入力してください'
                    }
                }
            },
            register_last_name: {
                validators: {
                    notEmpty: {
                        message: 'お名前(姓)を入力してください'
                    },
                    stringLength: {
                        max: 20,
                        message: '全角10文字まで'
                    }
                }
            },
            register_first_name: {
                validators: {
                    notEmpty: {
                        message: 'お名前(名)を入力してください'
                    },
                    stringLength: {
                        max: 20,
                        message: '全角10文字まで'
                    }
                }
            },
            register_email: {
                validators: {
                    notEmpty: {
                        message: 'メールアドレスを入力してください'
                    },
                    emailAddress: {
                        message: '有効なメールアドレスを入力してください'
                    }
                }
            },
            register_password: {
                validators: {
                    notEmpty: {
                        message: 'パスワードを入力してください'
                    },
                    stringLength: {
                        min: 5,
                        max: 20,
                        message: '5 ～ 20文字で作成してください'
                    },
                    regexp: {
                        regexp: /(?=(.*[0-9])+|(.*[ !\"#$%&'()*+,\-.\/:;<=>?@\[\\\]^_`{|}~])+)(?=(.*[a-z])+)(?=(.*[A-Z])+)[0-9a-zA-Z !\"#$%&'()*+,\-.\/:;<=>?@\[\\\]^_`{|}~]{8,}/g,
                        message: '大文字、小文字、数字、ASCIIシンボルを含む半角の文字列で登録してください'
                    },
                    identical: {
                    field: 'confirm_register_password',
                    message: 'パスワードが一致しません'
                    }
                }
            },
            confirm_register_password: {
                validators: {
                    notEmpty: {
                        message: 'パスワードを再度入力してください'
                    },
                    stringLength: {
                        min: 5,
                        max: 20,
                        message: '5 ～ 20文字で作成してください'
                    },
                    regexp: {
                        regexp: /(?=(.*[0-9])+|(.*[ !\"#$%&'()*+,\-.\/:;<=>?@\[\\\]^_`{|}~])+)(?=(.*[a-z])+)(?=(.*[A-Z])+)[0-9a-zA-Z !\"#$%&'()*+,\-.\/:;<=>?@\[\\\]^_`{|}~]{8,}/g,
                        message: '大文字、小文字、数字、ASCIIシンボルを含む半角の文字列で登録してください'
                    },
                    identical: {
                    field: 'register_password',
                    message: 'パスワードが一致しません'
                    }
                }
            }
        }
    });

    $('#registerModal').on('shown.bs.modal', function() {
        $('.register_form').bootstrapValidator('resetForm', true);
    });

    window.scroll($.cookie("x"), $.cookie("y"));
});

function wrapperSubmit(callObj) {

      var large_id = document.getElementsByName('large_id');
      var middle_id = document.getElementsByName('middle_id');
      var small_id = document.getElementsByName('small_id');
      var large_id_is_not_checked = true;
      var middle_id_is_not_checked = true;

      if (callObj.name == 'large_id') {
        for(var i=0; i < middle_id.length; i++)
        {
        middle_id[i].checked = false;
        }
        for(var i=0; i < small_id.length; i++)
        {
        small_id[i].checked = false;
        }
      }
      if (callObj.name == 'middle_id') {
        for(var i=0; i < small_id.length; i++)
        {
        small_id[i].checked = false;
        }
        for(var i=0; i < large_id.length; i++)
        {
          if(large_id[i].checked == true)
          {
            large_id_is_not_checked = false;
          }
        }
        if(large_id_is_not_checked == true) {
          large_id[0].checked = true;
        }
      }

      if (callObj.name == 'small_id') {
        for(var i=0; i < large_id.length; i++)
        {
          if(large_id[i].checked == true)
          {
            large_id_is_not_checked = false;
          }
        }
        if(large_id_is_not_checked == true) {
          large_id[0].checked = true;
        }
        for(var i=0; i < middle_id.length; i++)
        {
          if(middle_id[i].checked == true)
          {
            middle_id_is_not_checked = false;
          }
        }
        if(middle_id_is_not_checked == true) {
          middle_id[0].checked = true;
        }
      }

    document.cookie = 'x = ' + document.body.scrollLeft;
    document.cookie = 'y = ' + document.body.scrollTop;
    document.forms['search_form'].submit();
}

function clearAll() {
  var large_id = document.getElementsByName('large_id');
  var middle_id = document.getElementsByName('middle_id');
  var small_id = document.getElementsByName('small_id');

  for(var i=0; i < large_id.length; i++)
    {
      large_id[i].checked = false;
    }
    for(var i=0; i < middle_id.length; i++)
    {
      middle_id[i].checked = false;
    }
    for(var i=0; i < small_id.length; i++)
    {
      small_id[i].checked = false;
    }
    document.forms['search_form'].submit();
}

function createPDF() {
	document.search_form.action = "CreatePDF";
	document.search_form.target = "_blank";
	document.search_form.submit();
	document.search_form.action = "Search";
	document.search_form.removeAttribute('target');
}

function submitPage(page) {
	document.cookie = 'x = ' + document.body.scrollLeft;
	document.cookie = 'y = ' + document.body.scrollTop;
	document.getElementById("page").value = page;
	console.log(document.getElementById("page").value);
	document.search_form.submit();
}

function toggleAll(source, name) {
    checkboxes = document.getElementsByName(name);
    for(var i=0; i < checkboxes.length; i++) {
      checkboxes[i].checked = source.checked;
    }
  }
