package cardSystem.view
{
   import cardSystem.data.CardInfo;
   import cardSystem.view.cardBag.CardBagView;
   import cardSystem.view.cardEquip.CardEquipView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CardView extends Sprite implements Disposeable
   {
       
      
      private var _cardEquip:CardEquipView;
      
      private var _cardBag:CardBagView;
      
      private var _playerInfo:PlayerInfo;
      
      private var _helpBtn:BaseButton;
      
      private var _helpFrame:Frame;
      
      private var _okBtn:TextButton;
      
      private var _content:Bitmap;
      
      public function CardView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._cardEquip = ComponentFactory.Instance.creatCustomObject("cardEquipView");
         this._cardBag = new CardBagView();
         PositionUtils.setPos(this._cardBag,"CardBagListView.Pos");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("UpGradeFrame.helpBtn");
         PositionUtils.setPos(this._helpBtn,"cardView.helpBtnPos");
         addChild(this._cardEquip);
         addChild(this._cardBag);
         addChild(this._helpBtn);
      }
      
      public function set playerInfo(param1:PlayerInfo) : void
      {
         if(this._playerInfo == param1)
         {
            return;
         }
         this._playerInfo = param1;
         this._cardEquip.playerInfo = param1;
      }
      
      private function initEvent() : void
      {
         this._cardBag.addEventListener(CellEvent.DRAGSTART,this.__dragStartHandler);
         this._cardBag.addEventListener(CellEvent.DRAGSTOP,this.__dragStopHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpHandler);
      }
      
      private function removeEvent() : void
      {
         this._cardBag.removeEventListener(CellEvent.DRAGSTART,this.__dragStartHandler);
         this._cardBag.removeEventListener(CellEvent.DRAGSTOP,this.__dragStopHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpHandler);
      }
      
      private function __dragStartHandler(param1:CellEvent) : void
      {
         var _loc2_:CardInfo = param1.data as CardInfo;
         if(_loc2_.templateInfo.Property8 == "1")
         {
            this._cardEquip.shineMain();
         }
         else
         {
            this._cardEquip.shineVice();
         }
      }
      
      private function __dragStopHandler(param1:CellEvent) : void
      {
         this._cardEquip.stopShine();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._cardEquip)
         {
            this._cardEquip.dispose();
         }
         this._cardEquip = null;
         if(this._cardBag)
         {
            this._cardBag.dispose();
         }
         this._cardBag = null;
         if(this._helpBtn)
         {
            ObjectUtils.disposeObject(this._helpBtn);
         }
         this._helpBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      private function __helpHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._helpFrame == null)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("cardView.helpFrame");
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("UpGradeFrame.helpFrame.OK");
            PositionUtils.setPos(this._okBtn,"cardView.okBtnPos");
            this._content = ComponentFactory.Instance.creatBitmap("asset.cardSystem.help.content");
            this._okBtn.text = LanguageMgr.GetTranslation("ok");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("ddt.cardSystem.cardView.explain");
            this._helpFrame.addToContent(this._okBtn);
            this._helpFrame.addToContent(this._content);
            this._okBtn.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      protected function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.disposeHelpFrame();
         }
      }
      
      private function disposeHelpFrame() : void
      {
         this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
         this._helpFrame.dispose();
         this._okBtn = null;
         this._content = null;
         this._helpFrame = null;
      }
      
      protected function __closeHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.disposeHelpFrame();
      }
   }
}
