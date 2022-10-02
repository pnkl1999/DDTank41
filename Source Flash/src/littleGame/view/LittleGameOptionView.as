package littleGame.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class LittleGameOptionView extends Sprite implements Disposeable
   {
       
      
      private var _leftView:OptionLeftView;
      
      private var _rightView:OptionRightView;
      
      public function LittleGameOptionView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._leftView = new OptionLeftView();
         addChild(this._leftView);
         this._rightView = new OptionRightView();
         addChild(this._rightView);
      }
      
      private function addEvent() : void
      {
      }
      
      public function dispose() : void
      {
         if(this._leftView)
         {
            ObjectUtils.disposeObject(this._leftView);
         }
         this._leftView = null;
         if(this._rightView)
         {
            ObjectUtils.disposeObject(this._rightView);
         }
         this._rightView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
