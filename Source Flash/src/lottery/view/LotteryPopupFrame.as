package lottery.view
{
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class LotteryPopupFrame extends Sprite implements Disposeable
   {
       
      
      protected var _btnOk:BaseButton;
      
      public function LotteryPopupFrame()
      {
         super();
         this.initFrame();
      }
      
      protected function initFrame() : void
      {
      }
      
      protected function __btnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      public function dispose() : void
      {
         this._btnOk.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         if(this._btnOk)
         {
            ObjectUtils.disposeObject(this._btnOk);
         }
         this._btnOk = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
