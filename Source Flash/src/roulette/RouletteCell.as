package roulette
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class RouletteCell extends BaseCell
   {
       
      
      private var _selected:Boolean;
      
      private var _count:int;
      
      private var _boolCreep:Boolean;
      
      private var _selectMovie:MovieClip;
      
      private var _selectBG:Bitmap;
      
      public function RouletteCell(param1:DisplayObject)
      {
         super(param1);
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
         this._selectMovie = ComponentFactory.Instance.creat("asset.roulette.GlintAsset");
         addChild(this._selectMovie);
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
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
