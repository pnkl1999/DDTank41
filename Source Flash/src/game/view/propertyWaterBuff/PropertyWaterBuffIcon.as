package game.view.propertyWaterBuff
{
   import bagAndInfo.cell.CellContentCreator;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class PropertyWaterBuffIcon extends Sprite implements Disposeable, ITipedDisplay
   {
      
      public static const defaultW:int = 32;
      
      public static const defaultH:int = 32;
       
      
      private var _buffInfo:BuffInfo;
      
      private var _pic:CellContentCreator;
      
      private var _tipStyle:String;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      public function PropertyWaterBuffIcon(param1:BuffInfo)
      {
         super();
         this._buffInfo = param1;
         this.init();
      }
      
      private function init() : void
      {
         graphics.beginFill(16777215,0.2);
         graphics.drawRect(x,y,33,33);
         graphics.endFill();
         this.createPic();
         ShowTipManager.Instance.addTip(this);
      }
      
      private function createPic() : void
      {
         ObjectUtils.disposeObject(this._pic);
         this._pic = null;
         this._pic = new CellContentCreator();
         this._pic.info = this._buffInfo.buffItemInfo;
         this._pic.loadSync(this.createContentComplete);
         addChild(this._pic);
      }
      
      protected function createContentComplete() : void
      {
         this._pic.scaleX = defaultW / this._pic.width;
         this._pic.scaleY = defaultH / this._pic.height;
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeObject(this._pic);
         this._pic = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipData() : Object
      {
         return this._buffInfo;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._buffInfo = param1 as BuffInfo;
         this.createPic();
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
