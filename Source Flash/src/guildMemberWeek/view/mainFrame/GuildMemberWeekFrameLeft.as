package guildMemberWeek.view.mainFrame
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import guildMemberWeek.items.ShowGuildMemberDataItem;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class GuildMemberWeekFrameLeft extends Sprite implements Disposeable
   {
       
      
      private var _itemList:Vector.<ShowGuildMemberDataItem>;
      
      private var _list:VBox;
      
      public function GuildMemberWeekFrameLeft()
      {
         super();
         this.initView();
      }
      
      public function set itemList(param1:Vector.<ShowGuildMemberDataItem>) : void
      {
         this._itemList = param1;
      }
      
      public function get itemList() : Vector.<ShowGuildMemberDataItem>
      {
         return this._itemList;
      }
      
      private function initView() : void
      {
         var _loc3_:ShowGuildMemberDataItem = null;
         this._list = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.RankingTopTenListBox");
         this.itemList = new Vector.<ShowGuildMemberDataItem>();
         var _loc1_:int = 10;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = ComponentFactory.Instance.creatCustomObject("guildmemberweek.MainFrame.Left.ShowGuildMemberDataItem");
            _loc3_.initView(_loc2_ + 1);
            _loc3_.initAddPointBook(0);
            _loc3_.initItemCell(GuildMemberWeekManager.instance.model.TopTenGiftData[_loc2_]);
            this.itemList.push(_loc3_);
            this._list.addChild(this.itemList[_loc2_]);
            _loc2_++;
         }
         addChild(this._list);
         this.UpTop10data("Gift");
      }
      
      public function UpTop10data(param1:String) : void
      {
         var _loc2_:int = 10;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == "Member")
            {
               if(GuildMemberWeekManager.instance.model.TopTenMemberData[_loc3_] != null)
               {
                  this.itemList[_loc3_].initMember(GuildMemberWeekManager.instance.model.TopTenMemberData[_loc3_][1],GuildMemberWeekManager.instance.model.TopTenMemberData[_loc3_][3]);
               }
            }
            else if(param1 == "PointBook")
            {
               this.itemList[_loc3_].initAddPointBook(GuildMemberWeekManager.instance.model.TopTenAddPointBook[_loc3_]);
            }
            else if(param1 == "Gift")
            {
               this.itemList[_loc3_].initItemCell(GuildMemberWeekManager.instance.model.TopTenGiftData[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      private function disposeItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.itemList)
         {
            _loc1_ = 0;
            _loc2_ = this.itemList.length;
            while(_loc1_ < _loc2_)
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
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
