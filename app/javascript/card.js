const pay = () => {
  // 必要な要素が存在するかチェック
  const numberForm = document.getElementById('number-form');
  const expiryForm = document.getElementById('expiry-form');
  const cvcForm = document.getElementById('cvc-form');
  const chargeForm = document.getElementById('charge-form');
  
  // いずれかの要素が見つからない場合は処理を中断
  if (!numberForm || !expiryForm || !cvcForm || !chargeForm) {
    return;
  }
  const publicKey = gon.public_key;
  const payjp = Payjp(publicKey)
  const elements = payjp.elements();
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  // 要素が存在することを確認してからmount
  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');
  
  const form = document.getElementById('charge-form')
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    
    payjp.createToken(numberElement).then(function (response) {
      if (response.error) {
        console.error('PAY.JPエラー:', response.error);
      } else {
        const token = response.id;
        
        // トークンを隠しフィールドとして追加
        const tokenObj = `<input value="${token}" name="payjp_token" type="hidden">`;
        form.insertAdjacentHTML("beforeend", tokenObj);
        
        // フィールドをクリア
        numberElement.clear();
        expiryElement.clear();
        cvcElement.clear();
        
        // フォーム送信
        form.submit();
      }
    }).catch(function(error) {
      console.error('createTokenでエラーが発生しました:', error);
    });
  });
};

// Turboに依存しないDOMContentLoadedイベントを使用
document.addEventListener("DOMContentLoaded", pay);
