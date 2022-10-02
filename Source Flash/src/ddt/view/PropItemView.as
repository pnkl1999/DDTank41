package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.data.PropInfo;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.Dictionary;
   
   public class PropItemView extends Sprite implements ITipedDisplay, Disposeable
   {
      
      public static const OVER:String = "over";
      
      public static const OUT:String = "out";
      
      public static var _prop:Dictionary;
       
      
      private var _info:PropInfo;
      
      private var _asset:Bitmap;
      
      private var _isExist:Boolean;
      
      private var _tipStyle:String;
      
      private var _tipData:Object;
      
      private var _tipDirctions:String;
      
      private var _tipGapV:int;
      
      private var _tipGapH:int;
      
      public function PropItemView(param1:PropInfo, param2:Boolean = true, param3:Boolean = true, param4:int = 1)
      {
         super();
         mouseEnabled = true;
         this._info = param1;
         this._isExist = param2;
         this._asset = PropItemView.createView(this._info.Template.Pic,38,38);
         this._asset.x = 1;
         this._asset.y = 1;
         if(!this._isExist)
         {
            filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         }
         addChild(this._asset);
         this.tipStyle = "core.ToolPropTips";
         this.tipDirctions = "2,7,5,1,6,4";
         this.tipGapH = 20;
         this.tipGapV = 20;
         var _loc5_:ToolPropInfo = new ToolPropInfo();
         _loc5_.info = param1.Template;
         _loc5_.count = param4;
         _loc5_.showPrice = param3;
         _loc5_.showThew = true;
         _loc5_.showCount = true;
         this.tipData = _loc5_;
         ShowTipManager.Instance.addTip(this);
         addEventListener(MouseEvent.MOUSE_OVER,this.__over);
         addEventListener(MouseEvent.MOUSE_OUT,this.__out);
      }
      
      public static function createView(param1:String, param2:int = 62, param3:int = 62, param4:Boolean = true) : Bitmap
      {
         var _loc5_:String = "game.crazyTank.view.Prop" + param1.toString() + "Asset";
         var _loc6_:Bitmap = ComponentFactory.Instance.creatBitmap(_loc5_);
         _loc6_.smoothing = param4;
         _loc6_.width = param2;
         _loc6_.height = param3;
         return _loc6_;
      }
      
      public function get info() : PropInfo
      {
         return this._info;
      }
      
      private function __out(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(PropItemView.OUT));
      }
      
      private function __over(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(PropItemView.OVER));
      }
      
      public function get isExist() : Boolean
      {
         return this._isExist;
      }
      
      public function dispose() : void
      {
         if(this._asset && this._asset.parent)
         {
            this._asset.parent.removeChild(this._asset);
         }
         this._asset.bitmapData.dispose();
         this._asset = null;
         this._info = null;
         ShowTipManager.Instance.removeTip(this);
         if(parent)
         {
            parent.removeChild(this);
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
         return this._tipGapV;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipStyle(param1:String) : void
      {
         if(this._tipStyle == param1)
         {
            return;
         }
         this._tipStyle = param1;
      }
      
      public function set tipData(param1:Object) : void
      {
         if(this._tipData == param1)
         {
            return;
         }
         this._tipData = param1;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         if(this._tipDirctions == param1)
         {
            return;
         }
         this._tipDirctions = param1;
      }
      
      public function set tipGapV(param1:int) : void
      {
         if(this._tipGapV == param1)
         {
            return;
         }
         this._tipGapV = param1;
      }
      
      public function set tipGapH(param1:int) : void
      {
         if(this._tipGapH == param1)
         {
            return;
         }
         this._tipGapH = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
