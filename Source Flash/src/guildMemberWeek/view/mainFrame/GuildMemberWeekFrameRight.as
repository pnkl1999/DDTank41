package guildMemberWeek.view.mainFrame
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import guildMemberWeek.items.AddRankingRecordItem;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class GuildMemberWeekFrameRight extends Sprite implements Disposeable
   {
       
      
      private var _panel:ScrollPanel;
      
      private var _list:VBox;
      
      private var _itemList:Vector.<AddRankingRecordItem>;
      
      public function GuildMemberWeekFrameRight()
      {
         super();
         this.initView();
      }
      
      public function set itemList(param1:Vector.<AddRankingRecordItem>) : void
      {
         this._itemList = param1;
      }
      
      public function get itemList() : Vector.<AddRankingRecordItem>
      {
         return this._itemList;
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.RankingRecordListBox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.MainFrameRight.scrollpanel");
         this.itemList = new Vector.<AddRankingRecordItem>();
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         addChild(this._panel);
      }
      
      public function ClearRecord() : void
      {
         this.disposeItems();
         this.itemList = new Vector.<AddRankingRecordItem>();
      }
      
      public function UpRecord() : void
      {
         var _loc3_:AddRankingRecordItem = null;
         var _loc1_:int = GuildMemberWeekManager.instance.model.AddRanking.length;
         var _loc2_:int = this.itemList.length;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = ComponentFactory.Instance.creatCustomObject("guildmemberweek.MainFrame.Right.AddRankingRecordItem");
            _loc3_.initText(GuildMemberWeekManager.instance.model.AddRanking[_loc2_]);
            this.itemList.push(_loc3_);
            this._list.addChild(this.itemList[_loc2_]);
            _loc2_++;
         }
         this._panel.invalidateViewport();
      }
      
      private function disposeItems() : void
      {
         var _loc1_:int = 0;
         if(this.itemList)
         {
            _loc1_ = 0;
            while(_loc1_ < this.itemList.length)
            {
               ObjectUtils.disposeObject(this.itemList[_loc1_]);
               this.itemList[_loc1_] = null;
               _loc1_++;
            }
            this.itemList = null;
         }
      }
      
      public function dispose() : void
      {
         this.disposeItems();
         ObjectUtils.disposeAllChildren(this._list);
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeAllChildren(this._panel);
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
