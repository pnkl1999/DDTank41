package effortView.completeIcon
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortRewardInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class EffortCompleteIconView extends Sprite implements Disposeable, ITipedDisplay
   {
      
      public static const MAX:int = 1;
      
      public static const MIN:int = 2;
       
      
      private var _iconBg:ScaleFrameImage;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _tipData:EffortInfo;
      
      private var _glowFilter:Array;
      
      public function EffortCompleteIconView()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         this.graphics.beginFill(16777215,0);
         this.graphics.drawRect(0,0,this.width,this.height);
         this.graphics.endFill();
         this._iconBg = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortCompleteIconView.EffortCompleteIconBg");
         this._iconBg.setFrame(MAX);
         addChild(this._iconBg);
         this._tipStyle = "effortView.effortCompleteIconTipsView";
         this._tipGapV = 5;
         this._tipGapH = 5;
         this._tipDirctions = "7,6,5";
         ShowTipManager.Instance.addTip(this);
         this._tipData = new EffortInfo();
         this._glowFilter = ComponentFactory.Instance.creatFrameFilters("GF_15");
         addEventListener(MouseEvent.MOUSE_OVER,this.__thisOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__thisOut);
      }
      
      private function __thisOut(param1:MouseEvent) : void
      {
         this.filters = null;
      }
      
      private function __thisOver(param1:MouseEvent) : void
      {
         this.filters = this._glowFilter[0];
      }
      
      public function setInfo(param1:EffortInfo) : void
      {
         this._tipData = param1;
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:int = 0;
         if(this._tipData.effortRewardArray)
         {
            _loc1_ = 0;
            while(_loc1_ < this._tipData.effortRewardArray.length)
            {
               if((this._tipData.effortRewardArray[_loc1_] as EffortRewardInfo).RewardType == 1)
               {
                  this._iconBg.setFrame(MAX);
               }
               _loc1_++;
            }
         }
         else
         {
            this._iconBg.setFrame(MIN);
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__thisOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__thisOut);
         if(this._iconBg)
         {
            this._iconBg.dispose();
            this._iconBg = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return 0;
      }
      
      public function get tipGapH() : int
      {
         return 0;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1 as EffortInfo;
         this.update();
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function get tipWidth() : int
      {
         return 0;
      }
      
      public function set tipWidth(param1:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
