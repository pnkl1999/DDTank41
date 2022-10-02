package surpriseRoulette.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SurpriseRouletteCell extends BaseCell
   {
       
      
      private var _bmpBg:Bitmap;
      
      private var _txtCount:FilterFrameText;
      
      private var _text_x:int;
      
      private var _text_y:int;
      
      private var _count:int;
      
      private var _mc:MovieClip;
      
      public function SurpriseRouletteCell(param1:DisplayObject, param2:int, param3:int)
      {
         super(param1);
         this._text_x = param2;
         this._text_y = param3;
         this.initView();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         PicPos = new Point(-21,-21);
         surpriseRouletteCellGQ = true;
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
         addChild(this._txtCount);
         if(this._count <= 1)
         {
            this._txtCount.text = "";
            return;
         }
         this._txtCount.text = String(this._count);
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      private function initView() : void
      {
         var _loc1_:Rectangle = null;
         _loc1_ = null;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("surpriseRoulette.rectGlow");
         this._mc = ComponentFactory.Instance.creat("asset.awardSystem.roulette.SelectGlintAsset");
         this._mc.visible = false;
         this._mc.width = this._mc.height = _loc1_.width;
         this._mc.x = _loc1_.x;
         this._mc.y = _loc1_.y;
         addChild(this._mc);
         this._txtCount = ComponentFactory.Instance.creat("roulette.RouletteCellCount");
         this._txtCount.x = this._text_x;
         this._txtCount.y = this._text_y;
         addChild(this._txtCount);
         tipDirctions = "1,2,7,0";
      }
      
      public function setEffect(param1:Number) : void
      {
         scaleX = scaleY = param1;
         if(param1 == 1)
         {
            this._mc.visible = false;
         }
         else
         {
            this._mc.gotoAndStop(1);
            this._mc.visible = true;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._bmpBg = null;
         this._txtCount = null;
      }
   }
}
