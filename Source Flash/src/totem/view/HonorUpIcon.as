package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import totem.HonorUpManager;
   
   public class HonorUpIcon extends Sprite implements Disposeable
   {
       
      
      private var _iconBtn:SimpleBitmapButton;
      
      private var _countTxt:FilterFrameText;
      
      public function HonorUpIcon()
      {
         super();
         this.mouseEnabled = false;
         this._iconBtn = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpIcon.btn");
         this._iconBtn.addEventListener(MouseEvent.CLICK,this.openHonorUpFrame,false,0,true);
         this._iconBtn.enable = false;
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpIcon.countTxt");
         addChild(this._iconBtn);
         addChild(this._countTxt);
         HonorUpManager.instance.addEventListener(HonorUpManager.UP_COUNT_UPDATE,this.refreshShow,false,0,true);
         if(HonorUpManager.instance.upCount >= 0)
         {
            this.refreshShow(null);
         }
         else
         {
            SocketManager.Instance.out.sendHonorUp(1,false);
         }
      }
      
      private function refreshShow(param1:Event) : void
      {
         this._iconBtn.enable = true;
		 SocketManager.Instance.out.sendErrorMsg("dataList: " + HonorUpManager.instance.dataList.length);
		 SocketManager.Instance.out.sendErrorMsg("upCount: " + HonorUpManager.instance.upCount);
		 SocketManager.Instance.out.sendErrorMsg("_countTxt 1: " + this._countTxt.text);
         this._countTxt.text = (HonorUpManager.instance.dataList.length - HonorUpManager.instance.upCount).toString();
		 SocketManager.Instance.out.sendErrorMsg("_countTxt 2: " + this._countTxt.text);
      }
      
      private function openHonorUpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(HonorUpManager.instance.upCount >= HonorUpManager.instance.dataList.length)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.totem.honorUp.cannot"));
            return;
         }
         var _loc2_:HonorUpFrame = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpFrame");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         this._iconBtn.removeEventListener(MouseEvent.CLICK,this.openHonorUpFrame);
         HonorUpManager.instance.removeEventListener(HonorUpManager.UP_COUNT_UPDATE,this.refreshShow);
         ObjectUtils.disposeAllChildren(this);
         this._iconBtn = null;
         this._countTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
