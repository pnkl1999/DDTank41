package fightLib.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class FightLibAwardView extends Component implements Disposeable
   {
      
      private static const P_backColor:String = "P_backColor";
      
      private static const ColumnCount:int = 5;
       
      
      private var _gift:int;
      
      private var _exp:int;
      
      private var _medal:int;
      
      private var _items:Array;
      
      private var _awardExpField:FilterFrameText;
      
      private var _awardGiftField:FilterFrameText;
      
      private var _backColor:int = 0;
      
      private var _hasGeted:Boolean = false;
      
      private var _list:SimpleTileList;
      
      private var _scrollPane:ScrollPanel;
      
      private var _title:Bitmap;
      
      private var _geted:Bitmap;
      
      private var _expShape:Bitmap;
      
      private var _giftShape:Bitmap;
      
      private var _maskShape:Sprite;
      
      private var _TipsText:Bitmap;
      
      private var _cells:Array;
      
      public function FightLibAwardView()
      {
         this._cells = [];
         super();
      }
      
      public function set backColor(param1:int) : void
      {
         this._backColor = param1;
         onPropertiesChanged(P_backColor);
      }
      
      public function get backColor() : int
      {
         return this._backColor;
      }
      
      override public function draw() : void
      {
         this.drawBackground();
         super.draw();
      }
      
      override public function dispose() : void
      {
         if(this._awardExpField)
         {
            ObjectUtils.disposeObject(this._awardExpField);
            this._awardExpField = null;
         }
         if(this._awardGiftField)
         {
            ObjectUtils.disposeObject(this._awardGiftField);
            this._awardGiftField = null;
         }
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
            this._list = null;
         }
         if(this._scrollPane)
         {
            ObjectUtils.disposeObject(this._scrollPane);
            this._list = null;
         }
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
            this._title = null;
         }
         if(this._geted)
         {
            ObjectUtils.disposeObject(this._geted);
            this._geted = null;
         }
         if(this._expShape)
         {
            ObjectUtils.disposeObject(this._expShape);
            this._expShape = null;
         }
         if(this._giftShape)
         {
            ObjectUtils.disposeObject(this._giftShape);
            this._giftShape = null;
         }
         if(this._TipsText)
         {
            ObjectUtils.disposeObject(this._TipsText);
            this._TipsText = null;
         }
         super.dispose();
      }
      
      override protected function init() : void
      {
         super.init();
         this._expShape = ComponentFactory.Instance.creatBitmap("fightLib.Award.Type1");
         addChild(this._expShape);
         this._giftShape = ComponentFactory.Instance.creatBitmap("fightLib.Award.Type6");
         addChild(this._giftShape);
         this._awardExpField = ComponentFactory.Instance.creatComponentByStylename("fightLib.Award.AwardExpField");
         addChild(this._awardExpField);
         this._awardGiftField = ComponentFactory.Instance.creatComponentByStylename("fightLib.Award.AwardGiftField");
         addChild(this._awardGiftField);
         this._scrollPane = ComponentFactory.Instance.creatComponentByStylename("fightLib.Award.AwardScrollPanel");
         addChild(this._scrollPane);
         this._list = new SimpleTileList(2);
         this._list.hSpace = 112;
         this._list.vSpace = 8;
         this._scrollPane.setView(this._list);
         this._maskShape = new Sprite();
         this._maskShape.graphics.beginFill(0,0.6);
         this._maskShape.graphics.drawRect(0,0,319,333);
         this._maskShape.graphics.endFill();
         addChild(this._maskShape);
         this._maskShape.visible = false;
         this._geted = ComponentFactory.Instance.creatBitmap("fightLib.Award.Geted");
         addChild(this._geted);
         this._title = ComponentFactory.Instance.creatBitmap("fightLib.Award.Title");
         addChild(this._title);
         this._TipsText = ComponentFactory.Instance.creatBitmap("fightLib.Award.TipsText");
         addChild(this._TipsText);
      }
      
      private function drawBackground() : void
      {
         var _loc1_:Graphics = graphics;
         _loc1_.clear();
         _loc1_.beginFill(this._backColor);
         _loc1_.drawRect(0,0,_width <= 0 ? Number(Number(1)) : Number(Number(_width)),_height <= 0 ? Number(Number(1)) : Number(Number(_height)));
         _loc1_.endFill();
      }
      
      public function setGiftAndExpNum(param1:int, param2:int, param3:int) : void
      {
         this._gift = param1;
         this._exp = param2;
         this._medal = param3;
         this.updateTxt();
      }
      
      public function setAwardItems(param1:Array) : void
      {
         this._items = param1;
         this.updateList();
      }
      
      private function updateTxt() : void
      {
         if(this._exp > 0)
         {
            this._awardExpField.text = this._exp.toString() + " ,";
         }
         if(this._gift > 0)
         {
            this._awardGiftField.text = this._gift.toString() + " ,";
         }
      }
      
      private function updateList() : void
      {
         var _loc4_:Object = null;
         var _loc5_:ItemTemplateInfo = null;
         var _loc1_:AwardCell = this._cells.shift();
         while(_loc1_ != null)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = this._cells.shift();
         }
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("fightLib.Award.AwardList.cell.PicPos");
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("fightLib.Award.AwardList.cell.ContentSize");
         for each(_loc4_ in this._items)
         {
            _loc5_ = ItemManager.Instance.getTemplateById(_loc4_.id);
            _loc1_ = ComponentFactory.Instance.creatCustomObject("fightLib.Award.AwardList.cell");
            _loc1_.info = _loc5_;
            _loc1_.count = _loc4_.count;
            this._list.addChild(_loc1_);
            this._cells.push(_loc1_);
         }
      }
      
      public function set geted(param1:Boolean) : void
      {
         if(this._hasGeted != param1)
         {
            this._hasGeted = param1;
            this._maskShape.visible = this._geted.visible = this._hasGeted;
         }
      }
      
      public function get geted() : Boolean
      {
         return this._hasGeted;
      }
   }
}
