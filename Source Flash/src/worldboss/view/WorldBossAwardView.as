package worldboss.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class WorldBossAwardView extends Sprite implements Disposeable
   {
       
      
      private var _leftView:WorldBossAwardOptionLeftView;
      
      private var _rightView:WorldBossAwardOptionRightView;
      
      public function WorldBossAwardView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._leftView = new WorldBossAwardOptionLeftView();
         addChild(this._leftView);
         this._rightView = new WorldBossAwardOptionRightView();
         addChild(this._rightView);
      }
      
      private function addEvent() : void
      {
         this._rightView.addEventListener(Event.CLOSE,this.__gotoBack);
      }
      
      private function __gotoBack(param1:Event) : void
      {
         this.dispose();
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
