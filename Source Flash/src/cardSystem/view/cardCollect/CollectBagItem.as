package cardSystem.view.cardCollect
{
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.elements.CardCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import road7th.data.DictionaryData;
   
   public class CollectBagItem extends Sprite implements Disposeable
   {
      
      public static const itemCellWidth:int = 78;
       
      
      private var _container:HBox;
      
      private var _setsInfo:SetsInfo;
      
      private var _setsName:GradientText;
      
      private var _cardsVector:Vector.<CardCell>;
      
      private var _seleted:Boolean;
      
      private var _itemBG:Scale9CornerImage;
      
      private var _light:ScaleBitmapImage;
      
      private var _itemInfo:DictionaryData;
      
      public function CollectBagItem()
      {
         super();
         this.initView();
      }
      
      public function set seleted(param1:Boolean) : void
      {
         this._seleted = param1;
         if(this._seleted)
         {
            this._light.visible = true;
         }
         else
         {
            this._light.visible = false;
         }
      }
      
      public function get seleted() : Boolean
      {
         return this._seleted;
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("CollectBagItem.BG");
         this._light = ComponentFactory.Instance.creat("CollectBagItem.light");
         this._setsName = ComponentFactory.Instance.creatComponentByStylename("CollectBagItem.setsName");
         this._container = ComponentFactory.Instance.creatComponentByStylename("CollectBagItem.container");
         addChild(this._itemBG);
         addChild(this._light);
         addChild(this._setsName);
         addChild(this._container);
         this._cardsVector = new Vector.<CardCell>(5);
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            this._cardsVector[_loc1_] = new CardCell(ComponentFactory.Instance.creatBitmap("asset.cardCollect.cardCellBG"));
            this._cardsVector[_loc1_].setContentSize(67,92);
            this._cardsVector[_loc1_].starVisible = false;
            this._cardsVector[_loc1_].mouseChildren = false;
            this._cardsVector[_loc1_].mouseEnabled = false;
            this._container.addChild(this._cardsVector[_loc1_]);
            _loc1_++;
         }
      }
      
      public function set setsInfo(param1:SetsInfo) : void
      {
         this._setsInfo = param1;
         this.upView();
      }
      
      public function get setsInfo() : SetsInfo
      {
         return this._setsInfo;
      }
      
      private function upView() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.seleted = false;
         var _loc1_:int = 0;
         if(this._setsInfo)
         {
            this._setsName.text = this._setsInfo.name;
            _loc1_ = this._setsInfo.cardIdVec.length;
            _loc2_ = 0;
            while(_loc2_ < 5)
            {
               if(_loc2_ < _loc1_)
               {
                  this._cardsVector[_loc2_].visible = true;
                  this._cardsVector[_loc2_].cardID = this._setsInfo.cardIdVec[_loc2_];
                  this._cardsVector[_loc2_].filters = null;
               }
               else
               {
                  this._cardsVector[_loc2_].visible = false;
               }
               _loc2_++;
            }
         }
         else
         {
            _loc1_ = 5;
            this._setsName.text = LanguageMgr.GetTranslation("ddt.cardSyste.bagItem.unkwon");
            _loc3_ = 0;
            while(_loc3_ < 5)
            {
               this._cardsVector[_loc3_].visible = true;
               this._cardsVector[_loc3_].cardInfo = null;
               this._cardsVector[_loc3_].showCardName(LanguageMgr.GetTranslation("ddt.cardSyste.bagItem.unkwon"));
               this._cardsVector[_loc3_].filters = ComponentFactory.Instance.creatFilters("grayFilter");
               _loc3_++;
            }
         }
         this._itemBG.width = itemCellWidth * _loc1_ + 12 + _loc1_ * 2;
         this._light.width = itemCellWidth * _loc1_ + 22 + _loc1_ * 2;
      }
      
      public function setSetsDate(param1:Vector.<CardInfo>) : void
      {
         var _loc5_:int = 0;
         var _loc2_:int = this._setsInfo.cardIdVec.length;
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(_loc3_ > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc3_)
               {
                  if(this._cardsVector[_loc4_].cardID == param1[_loc5_].TemplateID)
                  {
                     this._cardsVector[_loc4_].cardInfo = param1[_loc5_];
                     break;
                  }
                  if(_loc5_ == _loc3_ - 1)
                  {
                     this._cardsVector[_loc4_].cardInfo = null;
                     this._cardsVector[_loc4_].showCardName(ItemManager.Instance.getTemplateById(this._cardsVector[_loc4_].cardID).Name);
                  }
                  _loc5_++;
               }
            }
            else
            {
               this._cardsVector[_loc4_].cardInfo = null;
               this._cardsVector[_loc4_].showCardName(ItemManager.Instance.getTemplateById(this._cardsVector[_loc4_].cardID).Name);
            }
            _loc4_++;
         }
      }
      
      public function dispose() : void
      {
         this._setsInfo = null;
         this._itemInfo = null;
         ObjectUtils.disposeAllChildren(this);
         this._container = null;
         this._setsName = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._cardsVector.length)
         {
            this._cardsVector[_loc1_] = null;
            _loc1_++;
         }
         this._cardsVector = null;
         this._itemBG = null;
         this._light = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
