package bagAndInfo.info
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.Directions;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.view.tips.PropTxtTipInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class PropButton extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      protected var _back:DisplayObject;
      
      protected var _tipGapH:int = 0;
      
      protected var _tipGapV:int = 0;
      
      protected var _tipDirection:String;
      
      protected var _tipStyle:String = "core.PropTxtTips";
      
      protected var _tipData:PropTxtTipInfo;
      
      public function PropButton()
      {
         this._tipDirection = Directions.DIRECTION_BR + "," + Directions.DIRECTION_TR + "," + Directions.DIRECTION_BL + "," + Directions.DIRECTION_TL;
         this._tipData = new PropTxtTipInfo();
         super();
         mouseChildren = false;
         this.addChildren();
      }
      
      protected function addChildren() : void
      {
         if(!this._back)
         {
            this._back = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.background_propbutton");
            addChild(this._back);
         }
      }
      
      public function dispose() : void
      {
         if(this._back)
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get color() : int
      {
         return this._tipData.color;
      }
      
      public function set color(param1:int) : void
      {
         this._tipData.color = param1;
      }
      
      public function get property() : String
      {
         return this._tipData.property;
      }
      
      public function set property(param1:String) : void
      {
         this._tipData.property = "[" + param1 + "]";
      }
      
      public function get detail() : String
      {
         return this._tipData.detail;
      }
      
      public function set detail(param1:String) : void
      {
         this._tipData.detail = param1;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1 as PropTxtTipInfo;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirection;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirection = param1;
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
