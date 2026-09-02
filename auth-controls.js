(async()=>{
  if(document.getElementById('cls-logout-button')) return;
  try{
    const session=await fetch('/api/auth/session',{cache:'no-store'});
    if(!session.ok) return;
  }catch{return}

  const style=document.createElement('style');
  style.textContent='.cls-logout-button{position:fixed;z-index:70;right:18px;bottom:18px;width:46px;height:46px;border-radius:50%;display:grid;place-items:center;border:1px solid rgba(255,255,255,.12);background:rgba(17,19,24,.82);backdrop-filter:blur(14px);color:#9d9991;cursor:pointer;box-shadow:0 16px 38px rgba(0,0,0,.28);transition:.2s}.cls-logout-button:hover{color:#d1ad73;border-color:rgba(209,173,115,.55);transform:translateY(-2px)}.cls-logout-button svg{width:19px;height:19px}';
  document.head.appendChild(style);
  const button=document.createElement('button');
  button.id='cls-logout-button';
  button.className='cls-logout-button';
  button.type='button';
  button.setAttribute('aria-label','Sair do Catálogo S');
  button.title='Sair';
  button.innerHTML='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7"><path d="M12 3v9"></path><path d="M7.4 5.8a8 8 0 1 0 9.2 0"></path></svg>';
  button.addEventListener('click',()=>{location.href='/api/auth/logout'});
  document.body.appendChild(button);
})();
