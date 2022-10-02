package ddt.view.roulette
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class RouletteGoodsCell extends BaseCell
   {
       
      
      private var _selected:Boolean;
      
      private var _count:int;
      
      private var _boolCreep:Boolean;
      
      private var _selectMovie:MovieClip;
      
      private var count_txt:FilterFrameText;
      
      private var _text_x:int;
      
      private var _text_y:int;
      
      private var _selectBG:Bitmap;
      
      public function RouletteGoodsCell(param1:DisplayObject, param2:int, param3:int)
      {
         super(param1);
         this._text_x = param2;
         this._text_y = param3;
         this.initII();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _picPos = new Point(0,0);
      }
      
      protected function initII() : void
      {
         this._selectBG = ComponentFactory.Instance.creatBitmap("asset.awardSystem.roulette.SelectCellAsset");
         addChild(this._selectBG);
         this._selectMovie = ComponentFactory.Instance.creat("asset.awardSystem.roulette.SelectGlintAsset");
         addChild(this._selectMovie);
         this.count_txt = ComponentFactory.Instance.creat("roulette.RouletteCellCount");
         this.count_txt.x = this._text_x;
         this.count_txt.y = this._text_y;
         addChild(this.count_txt);
         this.count = 0;
         tipDirctions = "1,2,7,0";
      }
      
      public function setSparkle() : void
      {
         this.selected = true;
         this._selectMovie.gotoAndStop(1);
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
         this.count_txt.parent.removeChild(this.count_txt);
         addChild(this.count_txt);
         if(param1 <= 1)
         {
            this.count_txt.text = "";
            return;
         }
         this.count_txt.text = String(param1);
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function setGreep() : void
      {
         if(!this._boolCreep && this._selected)
         {
            this._selectMovie.gotoAndPlay(2);
            this._boolCreep = true;
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         this._selectMovie.visible = this._selected;
         if(this._selected == false)
         {
            this._boolCreep = false;
         }
      }
      
      public function set cellBG(param1:Boolean) : void
      {
         this._selectBG.visible = param1;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._selectBG)
         {
            ObjectUtils.disposeObject(this._selectBG);
         }
         this._selectBG = null;
         if(this._selectMovie)
         {
            ObjectUtils.disposeObject(this._selectMovie);
         }
         this._selectMovie = null;
         if(this.count_txt)
         {
            ObjectUtils.disposeObject(this.count_txt);
         }
         this.count_txt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
