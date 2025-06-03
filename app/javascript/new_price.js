const price = () => {
  const priceInput = document.getElementById('item-price');
  
  // 要素が存在しない場合は処理を中断（注文ページなど）
  if (!priceInput) {
    return;
  }
  
  priceInput.addEventListener('input', () => {
    const inputValue = priceInput.value;
    const addTaxDom = document.getElementById("add-tax-price");
    const addTaxProfitDom = document.getElementById("profit");
    
    // 安全にチェックしてから更新
    if (addTaxDom) {
      addTaxDom.innerHTML = Math.floor(inputValue * 0.1);
    }
    if (addTaxProfitDom) {
      addTaxProfitDom.innerHTML = Math.floor(inputValue - Math.floor(inputValue * 0.1));
    }
  });
};

window.addEventListener('turbo:load', price);
window.addEventListener('turbo:render', price);
