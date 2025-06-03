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

  // 既にマウント済みの場合は重複を避ける
  if (numberForm.hasChildNodes()) {
    return;
  }

  // gonオブジェクトが存在するかチェック
  if (typeof gon === 'undefined' || !gon.public_key) {
    return;
  }

  const publicKey = gon.public_key;
  const payjp = Payjp(publicKey)
  const elements = payjp.elements();
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  // 要素が存在することを確認してからmount
  try {
    numberElement.mount('#number-form');
    expiryElement.mount('#expiry-form');
    cvcElement.mount('#cvc-form');
  } catch (error) {
    console.error('PAY.JP要素のマウントでエラーが発生:', error);
    return;
  }
  
  const form = document.getElementById('charge-form')
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    
    // 必須フィールドの事前チェック
    const postNumber = document.getElementById('postal-code');
    const prefecture = document.getElementById('prefecture');
    const city = document.getElementById('city');
    const street = document.getElementById('addresses');
    const phoneNumber = document.getElementById('phone-number');
    
    // 空欄がある場合は通常のフォーム送信を行う（バリデーションエラーを表示）
    if (!postNumber?.value.trim() || 
        !prefecture?.value || prefecture?.value === '1' ||
        !city?.value.trim() || 
        !street?.value.trim() || 
        !phoneNumber?.value.trim()) {
      
      // PAY.JP処理をスキップして通常のフォーム送信
      form.submit();
      return;
    }
    
    // 全ての必須フィールドが入力済みの場合のみPAY.JP処理を実行
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

// turbo:renderとturbo:loadの両方に対応
document.addEventListener("turbo:render", pay);
document.addEventListener("turbo:load", pay);
