package effortView.rightView
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.tip.BaseTip;
   import ddt.data.effort.EffortInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.EffortEvent;
   import ddt.manager.EffortManager;
   import ddt.manager.SoundManager;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.tips.GoodTip;
   import effortView.EffortController;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class EffortRightHonorView extends Sprite implements Disposeable
   {
      
      public static const GOODSCLICK:String = "goods_click_awardsItem";
       
      
      private var _listPanel:ListPanel;
      
      private var _currentSelectItem:EffortInfo;
      
      private var _effortRigthItemArray:Array;
      
      private var _currentListArray:Array;
      
      private var _controller:EffortController;
      
      private var _goodTip:GoodTip;
      
      private var _tipStageClickCount:int;
      
      public function EffortRightHonorView(param1:EffortController)
      {
         super();
         this._controller = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("effortView.effortHonorlistPanel");
         this._listPanel.vScrollProxy = ScrollPanel.AUTO;
         this.update();
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListItemClick);
         addChild(this._listPanel);
         EffortManager.Instance.addEventListener(EffortEvent.TYPE_CHANGED,this.__typeChanged);
         var _loc1_:Vector.<IListCell> = this._listPanel.list.getAllCells();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            (_loc1_[_loc2_] as DisplayObject).addEventListener(EffortRightHonorView.GOODSCLICK,this.__goodsClick);
            _loc2_++;
         }
      }
      
      private function __goodsClick(param1:CaddyEvent) : void
      {
         this.showLinkGoodsInfo(param1.itemTemplateInfo,param1.point);
      }
      
      private function showLinkGoodsInfo(param1:ItemTemplateInfo, param2:Point, param3:uint = 0) : void
      {
         if(!this._goodTip)
         {
            this._goodTip = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTip");
         }
         this._goodTip.showTip(param1);
         this.setTipPos(this._goodTip,param2);
         this._tipStageClickCount = param3;
      }
      
      private function setTipPos(param1:BaseTip, param2:Point) : void
      {
         param1.x = param2.x - param1.width;
         param1.y = param2.y - param1.height - 10;
         if(param1.y < 0)
         {
            param1.y = 10;
         }
         StageReferance.stage.addChild(param1);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClickHandler);
      }
      
      private function __stageClickHandler(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         param1.stopPropagation();
         if(this._tipStageClickCount > 0)
         {
            if(this._goodTip)
            {
               this._goodTip.parent.removeChild(this._goodTip);
            }
            if(StageReferance.stage)
            {
               StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClickHandler);
            }
         }
         else
         {
            ++this._tipStageClickCount;
         }
      }
      
      private function __typeChanged(param1:EffortEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         if(EffortManager.Instance.isSelf)
         {
            switch(this._controller.currentViewType)
            {
               case 0:
                  this.setCurrentList(EffortManager.Instance.getHonorEfforts());
                  break;
               case 1:
                  this.setCurrentList(EffortManager.Instance.getCompleteHonorEfforts());
                  break;
               case 2:
                  this.setCurrentList(EffortManager.Instance.getInCompleteHonorEfforts());
            }
         }
         else
         {
            switch(this._controller.currentViewType)
            {
               case 0:
                  this.setCurrentList(EffortManager.Instance.getTempHonorEfforts());
                  break;
               case 1:
                  this.setCurrentList(EffortManager.Instance.getTempCompleteHonorEfforts());
                  break;
               case 2:
                  this.setCurrentList(EffortManager.Instance.getTempInCompleteHonorEfforts());
            }
         }
      }
      
      public function setCurrentList(param1:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this._currentListArray = [];
         this._effortRigthItemArray = [];
         var _loc2_:Array = param1;
         var _loc3_:Array = [];
         _loc2_.sortOn("ID",Array.DESCENDING);
         if(EffortManager.Instance.isSelf)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if((_loc2_[_loc4_] as EffortInfo).CompleteStateInfo)
               {
                  this._currentListArray.unshift(_loc2_[_loc4_]);
               }
               else
               {
                  _loc3_.unshift(_loc2_[_loc4_]);
               }
               _loc4_++;
            }
            this._currentListArray = this._currentListArray.concat(_loc3_);
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               if(EffortManager.Instance.tempEffortIsComplete(_loc2_[_loc5_].ID))
               {
                  this._currentListArray.unshift(_loc2_[_loc5_]);
               }
               else
               {
                  _loc3_.unshift(_loc2_[_loc5_]);
               }
               _loc5_++;
            }
            this._currentListArray = this._currentListArray.concat(_loc3_);
         }
         this.updateCurrentList();
      }
      
      private function updateCurrentList() : void
      {
         this._listPanel.vectorListModel.clear();
         this._listPanel.vectorListModel.appendAll(this._currentListArray);
         this._listPanel.list.updateListView();
      }
      
      private function __onListItemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentSelectItem)
         {
            this._currentSelectItem = param1.cellValue as EffortInfo;
         }
         if(this._currentSelectItem != param1.cellValue as EffortInfo)
         {
            this._currentSelectItem.isSelect = false;
         }
         this._currentSelectItem = param1.cellValue as EffortInfo;
         this._currentSelectItem.isSelect = true;
         this._listPanel.list.updateListView();
      }
      
      public function dispose() : void
      {
         EffortManager.Instance.removeEventListener(EffortEvent.TYPE_CHANGED,this.__typeChanged);
         if(this._currentSelectItem)
         {
            this._currentSelectItem.isSelect = false;
         }
         if(this._goodTip && this._goodTip.parent)
         {
            this._goodTip.parent.removeChild(this._goodTip);
         }
         this._goodTip = null;
         var _loc1_:Vector.<IListCell> = this._listPanel.list.getAllCells();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            (_loc1_[_loc2_] as DisplayObject).removeEventListener(EffortRightHonorView.GOODSCLICK,this.__goodsClick);
            _loc2_++;
         }
         if(this._listPanel && this._listPanel.parent)
         {
            this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListItemClick);
            this._listPanel.vectorListModel.clear();
            this._listPanel.parent.removeChild(this._listPanel);
            this._listPanel.dispose();
            this._listPanel = null;
         }
      }
   }
}
