package ddt.view.caddyII.card
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.view.caddyII.CaddyBagView;
   import ddt.view.caddyII.CaddyFrame;
   import ddt.view.caddyII.MoveSprite;
   
   public class CardFrame extends Frame
   {
       
      
      private var _view:CardViewII;
      
      private var _bag:CaddyBagView;
      
      private var _moveSprite:MoveSprite;
      
      public function CardFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         escEnable = true;
         this._view = ComponentFactory.Instance.creatCustomObject("caddy.CardViewII");
         addToContent(this._view);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._view.closeEnble)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.dontClose"));
            return;
         }
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      public function setCardType(param1:int, param2:int) : void
      {
         this._view.setCard(param1,param2);
      }
      
      public function setCardBox(param1:int, param2:int) : void
      {
         this._view.setCardBox(param1,param2);
      }
      
      public function show() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.view.card.title");
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
         y += CaddyFrame.VerticalOffset;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(this._view)
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
