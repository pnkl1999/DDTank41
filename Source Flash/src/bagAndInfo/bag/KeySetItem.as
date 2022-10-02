package bagAndInfo.bag
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.data.PropInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class KeySetItem extends ItemCellView implements IAcceptDrag, ITipedDisplay
   {
       
      
      private var _propIndex:int;
      
      private var _propID:int;
      
      private var _isGlow:Boolean = false;
      
      private var glow_mc:Bitmap;
      
      private var lightingFilter:ColorMatrixFilter;
      
      public function KeySetItem(param1:uint = 0, param2:int = 0, param3:int = 0, param4:DisplayObject = null, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this._propIndex = param2;
         this._propID = param3;
         this.glow_mc = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.keySetGlowAsset");
         addChild(this.glow_mc);
         this.glow_mc.visible = false;
         addEventListener(MouseEvent.ROLL_OVER,this.__over);
         addEventListener(MouseEvent.ROLL_OUT,this.__out);
         ShowTipManager.Instance.addTip(this);
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         DragManager.acceptDrag(this,DragEffect.NONE);
      }
      
      private function __over(param1:MouseEvent) : void
      {
         filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      private function __out(param1:MouseEvent) : void
      {
         filters = null;
      }
      
      public function set glow(param1:Boolean) : void
      {
         this._isGlow = param1;
         this.glow_mc.visible = this._isGlow;
      }
      
      public function get glow() : Boolean
      {
         return this._isGlow;
      }
      
      public function set propID(param1:int) : void
      {
         this._propID = param1;
      }
      
      public function get tipData() : Object
      {
         var _loc1_:PropInfo = new PropInfo(ItemManager.Instance.getTemplateById(this._propID));
         var _loc2_:ToolPropInfo = new ToolPropInfo();
         _loc2_.showThew = true;
         _loc2_.info = _loc1_.Template;
         if(this._propIndex)
         {
            _loc2_.shortcutKey = this._propIndex.toString();
         }
         return _loc2_;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function set tipData(param1:Object) : void
      {
      }
      
      public function get tipDirctions() : String
      {
         return "5,2,7,1,6,4";
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return -15;
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 5;
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return "core.ToolPropTips";
      }
      
      public function set tipStyle(param1:String) : void
      {
      }
      
      override public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         removeEventListener(MouseEvent.ROLL_OVER,this.__over);
         removeEventListener(MouseEvent.ROLL_OUT,this.__out);
         if(this.glow_mc && this.glow_mc.parent)
         {
            this.glow_mc.parent.removeChild(this.glow_mc);
         }
         this.glow_mc = null;
         this.lightingFilter = null;
         filters = null;
         super.dispose();
      }
   }
}
