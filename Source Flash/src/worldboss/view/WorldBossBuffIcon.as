package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import worldboss.WorldBossManager;
   
   public class WorldBossBuffIcon extends Sprite implements Disposeable
   {
       
      
      private var _buffBtn:BaseButton;
      
      private var _bufTip:ScaleBitmapImage;
      
      private var _bufTipTxt:FilterFrameText;
      
      public function WorldBossBuffIcon()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         if(WorldBossManager.Instance.bossInfo.buffArray.length > 0)
         {
            this._buffBtn = ComponentFactory.Instance.creat("worldbossRoom.buffBtn");
            addChild(this._buffBtn);
            this._bufTip = ComponentFactory.Instance.creat("worldBossRoom.buff.tipTxtBG");
            this._bufTipTxt = ComponentFactory.Instance.creat("worldBossRoom.buff.tipTxt");
            this._bufTipTxt.text = LanguageMgr.GetTranslation("wordlboss.room.tipText");
            this._bufTipTxt.visible = false;
            this._bufTip.visible = false;
            addChild(this._bufTip);
            addChild(this._bufTipTxt);
            this.addEvent();
         }
      }
      
      private function addEvent() : void
      {
         this._buffBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__buffBtnOver);
         this._buffBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__buffBtnOut);
         this._buffBtn.addEventListener(MouseEvent.CLICK,this.bugBuff);
      }
      
      private function removeEvent() : void
      {
         this._buffBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__buffBtnOver);
         this._buffBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__buffBtnOut);
         this._buffBtn.removeEventListener(MouseEvent.CLICK,this.bugBuff);
      }
      
      private function __buffBtnOver(param1:MouseEvent) : void
      {
         this._bufTipTxt.visible = true;
         this._bufTip.visible = true;
      }
      
      private function __buffBtnOut(param1:MouseEvent) : void
      {
         this._bufTipTxt.visible = false;
         this._bufTip.visible = false;
      }
      
      public function bugBuff(param1:MouseEvent = null) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:WorldBossBuyBuffFrame = ComponentFactory.Instance.creat("worldboss.buyBuff.Frame");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         _loc2_.addEventListener(Event.CHANGE,this.__updateBuff);
      }
      
      private function __updateBuff(param1:Event) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function dispose() : void
      {
         if(this._buffBtn)
         {
            this.removeEvent();
         }
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            this.parent.removeChild(this);
         }
         this._buffBtn = null;
         this._bufTip = null;
         this._bufTipTxt = null;
      }
   }
}
