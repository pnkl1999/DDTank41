package trainer.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import trainer.controller.LevelRewardManager;
   import trainer.data.LevelRewardInfo;
   
   public class LevelRewardItem extends Sprite
   {
       
      
      private var _level:int;
      
      private var _bg:Bitmap;
      
      private var _txt:Bitmap;
      
      private var _item2:LevelRewardInfo;
      
      private var _item3:LevelRewardInfo;
      
      private var _levelRewardListII:LevelRewardList;
      
      private var _levelRewardListIII:LevelRewardList;
      
      public function LevelRewardItem()
      {
         super();
      }
      
      public function setStyle(param1:int) : void
      {
         this._level = param1;
         this.initView();
      }
      
      private function initView() : void
      {
         this._item2 = LevelRewardManager.Instance.getRewardInfo(this._level,2);
         this._item3 = LevelRewardManager.Instance.getRewardInfo(this._level,3);
         this._bg = ComponentFactory.Instance.creatBitmap("asset.core.levelRewardBg2");
         addChild(this._bg);
         this.currentLevel();
         this._txt = ComponentFactory.Instance.creatBitmap("asset.core.levelRewardTxt");
         addChild(this._txt);
      }
      
      private function currentLevel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:BaseCell = null;
         var _loc4_:int = 0;
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:BaseCell = null;
         if(this._item2 != null)
         {
            if(this._item2.items.length > 0)
            {
               this._levelRewardListII = ComponentFactory.Instance.creatCustomObject("trainer.currentLevel.levelRewardListII");
               _loc1_ = 0;
               while(_loc1_ < this._item2.items.length)
               {
                  _loc2_ = ItemManager.Instance.getTemplateById(int(this._item2.items[_loc1_]));
                  _loc3_ = new LevelRewardCell(_loc2_);
                  this._levelRewardListII.addCell(_loc3_);
                  _loc1_++;
               }
               addChild(this._levelRewardListII);
            }
         }
         if(this._item3 != null)
         {
            if(this._item3.items.length > 0)
            {
               this._levelRewardListIII = ComponentFactory.Instance.creatCustomObject("trainer.currentLevel.levelRewardListIII");
               _loc4_ = 0;
               while(_loc4_ < this._item3.items.length)
               {
                  _loc5_ = ItemManager.Instance.getTemplateById(int(this._item3.items[_loc4_]));
                  _loc6_ = new LevelRewardCell(_loc5_);
                  this._levelRewardListIII.addCell(_loc6_);
                  _loc4_++;
               }
               addChild(this._levelRewardListIII);
            }
         }
         this.addListEvent();
      }
      
      private function addListEvent() : void
      {
         if(this._levelRewardListII)
         {
            this._levelRewardListII.addEventListener(MouseEvent.MOUSE_OVER,this.__onListOver);
         }
         if(this._levelRewardListIII)
         {
            this._levelRewardListIII.addEventListener(MouseEvent.MOUSE_OVER,this.__onListOver);
         }
      }
      
      private function removeListEvent() : void
      {
         if(this._levelRewardListII)
         {
            this._levelRewardListII.removeEventListener(MouseEvent.MOUSE_OVER,this.__onListOver);
         }
         if(this._levelRewardListIII)
         {
            this._levelRewardListIII.removeEventListener(MouseEvent.MOUSE_OVER,this.__onListOver);
         }
      }
      
      private function __onListOver(param1:MouseEvent) : void
      {
         addChild(param1.currentTarget as DisplayObject);
      }
      
      public function dispose() : void
      {
         this.removeListEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._bg = null;
         if(this._levelRewardListII)
         {
            this._levelRewardListII.disopse();
            this._levelRewardListII = null;
         }
         if(this._levelRewardListIII)
         {
            this._levelRewardListIII.disopse();
            this._levelRewardListIII = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
