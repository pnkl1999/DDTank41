package littleGame.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.view.ShopGoodItem;
   
   public class LittleAwardListView extends Sprite implements Disposeable
   {
      
      public static const AWARD_ITEM_NUM:uint = 8;
       
      
      private var _bg:MutipleImage;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _goodItems:Vector.<AwardGoodItem>;
      
      private var _firstPage:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _currentPage:int;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _paginationBg:Bitmap;
      
      private var _noteDesc:Bitmap;
      
      private var _list:Vector.<ShopItemInfo>;
      
      public function LittleAwardListView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("littleGame.AwardListBg");
         addChild(this._bg);
         this._noteDesc = ComponentFactory.Instance.creat("asset.littleGame.ScoreNote");
         addChild(this._noteDesc);
         this._paginationBg = ComponentFactory.Instance.creat("asset.shop.RightViewBg1");
         PositionUtils.setPos(this._paginationBg,"littleGame.paginationBg.pos");
         addChild(this._paginationBg);
         this._firstPage = ComponentFactory.Instance.creat("littleGame.BtnFirstPage");
         this._prePageBtn = ComponentFactory.Instance.creat("littleGame.BtnPrePage");
         this._nextPageBtn = ComponentFactory.Instance.creat("littleGame.BtnNextPage");
         this._endPageBtn = ComponentFactory.Instance.creat("littleGame.BtnEndPage");
         this._currentPageTxt = ComponentFactory.Instance.creatComponentByStylename("littleGame.CurrentPage");
         this._goodItems = new Vector.<AwardGoodItem>();
         this._goodItemContainerAll = new Sprite();
         PositionUtils.setPos(this._goodItemContainerAll,"littleGame.goodItemContainer.pos");
         for(var i:int = 0; i < AWARD_ITEM_NUM; i++)
         {
            this._goodItems[i] = ComponentFactory.Instance.creatCustomObject("littleGame.GoodItem");
            this._goodItemContainerAll.addChild(this._goodItems[i]);
            this._goodItems[i].addEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            this._goodItems[i].addEventListener(ItemEvent.ITEM_SELECT,this.__itemSelect);
         }
         DisplayUtils.horizontalArrange(this._goodItemContainerAll,2,14);
         addChild(this._firstPage);
         addChild(this._prePageBtn);
         addChild(this._nextPageBtn);
         addChild(this._endPageBtn);
         addChild(this._currentPageTxt);
         addChild(this._goodItemContainerAll);
         this._currentPage = 1;
         this.loadList();
      }
      
      private function addEvent() : void
      {
         this._firstPage.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
      }
      
      private function removeEvent() : void
      {
         this._firstPage.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         for(var i:uint = 0; i < AWARD_ITEM_NUM; i++)
         {
            this._goodItems[i].removeEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
         }
      }
      
      public function loadList() : void
      {
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(ShopType.LITTLEGAME_AWARD_TYPE,this._currentPage));
      }
      
      public function setList(list:Vector.<ShopItemInfo>) : void
      {
         this._list = list;
         this.clearitems();
         for(var i:int = 0; i < AWARD_ITEM_NUM; i++)
         {
            this._goodItems[i].selected = false;
            if(i < list.length && list[i])
            {
               this._goodItems[i].shopItemInfo = list[i];
            }
         }
         this._currentPageTxt.text = this._currentPage + "/" + ShopManager.Instance.getResultPages(ShopType.LITTLEGAME_AWARD_TYPE);
      }
      
      private function clearitems() : void
      {
         for(var i:int = 0; i < AWARD_ITEM_NUM; i++)
         {
            this._goodItems[i].shopItemInfo = null;
         }
      }
      
      private function __pageBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ShopManager.Instance.getResultPages(ShopType.LITTLEGAME_AWARD_TYPE) == 0)
         {
            return;
         }
         switch(evt.currentTarget)
         {
            case this._firstPage:
               if(this._currentPage != 1)
               {
                  this._currentPage = 1;
               }
               break;
            case this._prePageBtn:
               if(this._currentPage == 1)
               {
                  this._currentPage = ShopManager.Instance.getResultPages(ShopType.LITTLEGAME_AWARD_TYPE) + 1;
               }
               --this._currentPage;
               break;
            case this._nextPageBtn:
               if(this._currentPage == ShopManager.Instance.getResultPages(ShopType.LITTLEGAME_AWARD_TYPE))
               {
                  this._currentPage = 0;
               }
               ++this._currentPage;
               break;
            case this._endPageBtn:
               if(this._currentPage != ShopManager.Instance.getResultPages(ShopType.LITTLEGAME_AWARD_TYPE))
               {
                  this._currentPage = ShopManager.Instance.getResultPages(ShopType.LITTLEGAME_AWARD_TYPE);
               }
         }
         this.loadList();
      }
      
      private function __itemClick(evt:ItemEvent) : void
      {
      }
      
      private function __itemSelect(evt:ItemEvent) : void
      {
         var j:ISelectable = null;
         evt.stopImmediatePropagation();
         var item:ShopGoodItem = evt.currentTarget as ShopGoodItem;
         for each(j in this._goodItems)
         {
            j.selected = false;
         }
         item.selected = true;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._goodItemContainerAll);
         this._goodItemContainerAll = null;
         this._currentPageTxt.dispose();
         this._currentPageTxt = null;
         ObjectUtils.disposeObject(this._paginationBg);
         this._paginationBg = null;
         ObjectUtils.disposeObject(this._nextPageBtn);
         this._nextPageBtn = null;
         ObjectUtils.disposeObject(this._prePageBtn);
         this._prePageBtn = null;
         ObjectUtils.disposeObject(this._firstPage);
         this._firstPage = null;
         ObjectUtils.disposeObject(this._endPageBtn);
         this._endPageBtn = null;
         for(var i:int = 0; i < AWARD_ITEM_NUM; i++)
         {
            ObjectUtils.disposeObject(this._goodItems[i]);
            this._goodItems[i] = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
