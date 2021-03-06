<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Plaid Quickstart OAuth Response Page Example</title>
<link rel="stylesheet" href="https://threads.plaid.com/threads.css">

<link rel="stylesheet" type="text/css" href="style.css">
<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.3/jquery.min.js"></script>
  <script src="https://cdn.plaid.com/link/v2/stable/link-initialize.js"></script>
  <script>
  (function($) {
    var products = '<%= PLAID_PRODUCTS %>'.split(',');
    var linkHandlerCommonOptions = {
      apiVersion: 'v2',
      clientName: 'Plaid Quickstart',
      env: '${plaidEnvironment}',
      product: products,
      countryCodes: '${plaidCountryCodes}'.split(','),
    };
    var oauthNonce = '${plaidOAuthNonce}';
    if (oauthNonce == null || oauthNonce == '') {
      console.error('oauth_nonce should not be empty');
    }
    var oauthStateId = qs('oauth_state_id');
    if (oauthStateId == null || oauthStateId == '') {
      console.error('could not parse oauth_state_id from query parameters');
    }
    // Depends on the item_add_token being stored in session storage 
    // when Link is first initialized
    var itemAddToken = sessionStorage.getItem('item-add-token');
    if (itemAddToken == null || itemAddToken == '') {
      console.error('could not fetch item-add-token from session storage');
    }
    linkHandlerCommonOptions.oauthStateId = oauthStateId;
    var handler = Plaid.create({
      ...linkHandlerCommonOptions,
      token: itemAddToken,
      oauthNonce: oauthNonce,
      oauthStateId: oauthStateId,
      onSuccess: function(public_token) {
        $.post('/get_access_token', {public_token: public_token}, function(data) {
          location.href = 'http://localhost:8080';
        });
      },
    });
    handler.open();

  })(jQuery);

  function qs(key) {
    var match = location.search.match(new RegExp("[?&]"+key+"=([^&]+)(&|$)"));
    return match && decodeURIComponent(match[1].replace(/\+/g, " "));
  }

  </script>
</body>
</html>
