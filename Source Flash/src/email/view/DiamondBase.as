package email.view
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import email.data.EmailInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class DiamondBase extends Sprite implements Disposeable
   {
      
      private static var CELL_HEIGHT:int = 45;
      
      private static var CELL_WIDTH:int = 45;
       
      
      protected var _info:EmailInfo;
      
      public var diamondBg:Bitmap;
      
      public var chargedImg:Bitmap;
      
      public var centerMC:ScaleFrameImage;
      
      public var countTxt:FilterFrameText;
      
      private var _index:int;
      
      public var _cell:EmaillBagCell;
      
      function DiamondBase()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      protected function initView() : void
      {
         this._cell = new EmaillBagCell();
         this._cell.width = CELL_WIDTH;
         this._cell.height = CELL_HEIGHT;
         var cellPos:Point = ComponentFactory.Instance.creatCustomObject("email.cellPos");
         this._cell.x = cellPos.x;
         this._cell.y = cellPos.y;
         this._cell.allowDrag = false;
         addChild(this._cell);
         mouseChildren = false;
         mouseEnabled = false;
         this.diamondBg = ComponentFactory.Instance.creatBitmap("asset.email.DiamondBg");
         addChildAt(this.diamondBg,0);
         this.centerMC = ComponentFactory.Instance.creat("email.centerMC");
         addChild(this.centerMC);
         this.centerMC.setFrame(1);
         this.centerMC.visible = false;
         this.chargedImg = ComponentFactory.Instance.creatBitmap("asset.email.chargedImg");
         addChild(this.chargedImg);
         this.chargedImg.visible = false;
         this.countTxt = ComponentFactory.Instance.creat("email.diamondTxt");
         addChild(this.countTxt);
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(value:int) : void
      {
         if(this._index == value)
         {
            return;
         }
         this._index = value;
      }
      
      public function get info() : EmailInfo
      {
         return this._info;
      }
      
      public function set info(value:EmailInfo) : void
      {
         this._info = value;
         if(this._info)
         {
            this.update();
         }
         else
         {
            mouseEnabled = false;
            mouseChildren = false;
            this.centerMC.visible = false;
            this.chargedImg.visible = false;
            this.countTxt.text = "";
            this._cell.visible = false;
         }
      }
      
      public function forSendedCell() : void
      {
         this.centerMC.setFrame(5);
         this.diamondBg.visible = false;
         this.chargedImg.visible = false;
         this.countTxt.visible = false;
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         this._cell.dragDrop(effect);
      }
      
      protected function addEvent() : void
      {
      }
      
      protected function removeEvent() : void
      {
      }
      
      protected function update() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this.diamondBg)
         {
            ObjectUtils.disposeObject(this.diamondBg);
         }
         this.diamondBg = null;
         if(this.chargedImg)
         {
            ObjectUtils.disposeObject(this.chargedImg);
         }
         this.chargedImg = null;
         if(this.centerMC)
         {
            ObjectUtils.disposeObject(this.centerMC);
         }
         this.centerMC = null;
         if(this.countTxt)
         {
            ObjectUtils.disposeObject(this.countTxt);
         }
         this.countTxt = null;
         if(this._cell)
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         this._info = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
