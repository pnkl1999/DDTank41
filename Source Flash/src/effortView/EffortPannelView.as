package effortView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import effortView.leftView.EffortLeftView;
   import effortView.rightView.EffortFullView;
   import effortView.rightView.EffortRightHonorView;
   import effortView.rightView.EffortRightView;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class EffortPannelView extends Sprite implements Disposeable
   {
       
      
      private var _effortLeftView:EffortLeftView;
      
      private var _effoetRigthView:EffortRightView;
      
      private var _effoetFullView:EffortFullView;
      
      private var _effoetRigthHonorView:EffortRightHonorView;
      
      private var _controller:EffortController;
      
      public function EffortPannelView(param1:EffortController)
      {
         this._controller = param1;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._effortLeftView = new EffortLeftView(this._controller);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("effortView.EffortLeftView.EffortLeftViewPos");
         this._effortLeftView.x = _loc1_.x;
         this._effortLeftView.y = _loc1_.y;
         addChild(this._effortLeftView);
         this._effoetFullView = new EffortFullView(this._controller);
         addChild(this._effoetFullView);
      }
      
      private function initEvent() : void
      {
         this._controller.addEventListener(Event.CHANGE,this.__rightChange);
      }
      
      private function __rightChange(param1:Event) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         _loc2_ = null;
         _loc3_ = null;
         var _loc4_:Point = null;
         if(this._controller.currentRightViewType == 0)
         {
            if(this._effoetRigthView)
            {
               removeChild(this._effoetRigthView);
               this._effoetRigthView.dispose();
               this._effoetRigthView = null;
            }
            if(this._effoetRigthHonorView)
            {
               removeChild(this._effoetRigthHonorView);
               this._effoetRigthHonorView.dispose();
               this._effoetRigthHonorView = null;
            }
            if(!this._effoetFullView)
            {
               this._effoetFullView = new EffortFullView(this._controller);
               _loc2_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortLeftView.EffortFullViewPos");
               this._effoetFullView.x = _loc2_.x;
               this._effoetFullView.y = _loc2_.y;
               addChild(this._effoetFullView);
            }
         }
         else if(this._controller.currentRightViewType == 6)
         {
            if(this._effoetRigthView)
            {
               removeChild(this._effoetRigthView);
               this._effoetRigthView.dispose();
               this._effoetRigthView = null;
            }
            if(this._effoetFullView)
            {
               removeChild(this._effoetFullView);
               this._effoetFullView.dispose();
               this._effoetFullView = null;
            }
            if(!this._effoetRigthHonorView)
            {
               this._effoetRigthHonorView = new EffortRightHonorView(this._controller);
               _loc3_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortLeftView.EffortRightViewPos");
               this._effoetRigthHonorView.x = _loc3_.x;
               this._effoetRigthHonorView.y = _loc3_.y;
               addChild(this._effoetRigthHonorView);
            }
         }
         else
         {
            if(this._effoetRigthHonorView)
            {
               removeChild(this._effoetRigthHonorView);
               this._effoetRigthHonorView.dispose();
               this._effoetRigthHonorView = null;
            }
            if(this._effoetFullView)
            {
               removeChild(this._effoetFullView);
               this._effoetFullView.dispose();
            }
            this._effoetFullView = null;
            if(!this._effoetRigthView)
            {
               this._effoetRigthView = new EffortRightView(this._controller);
               _loc4_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortLeftView.EffortRightViewPos");
               this._effoetRigthView.x = _loc4_.x;
               this._effoetRigthView.y = _loc4_.y;
               addChild(this._effoetRigthView);
            }
         }
      }
      
      public function dispose() : void
      {
         if(this._effoetRigthView)
         {
            removeChild(this._effoetRigthView);
            this._effoetRigthView.dispose();
            this._effoetRigthView = null;
         }
         if(this._effoetFullView)
         {
            removeChild(this._effoetFullView);
            this._effoetFullView.dispose();
            this._effoetFullView = null;
         }
         if(this._effortLeftView)
         {
            removeChild(this._effortLeftView);
            this._effortLeftView.dispose();
         }
         if(this._effoetRigthHonorView)
         {
            removeChild(this._effoetRigthHonorView);
            this._effoetRigthHonorView.dispose();
            this._effoetRigthHonorView = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
