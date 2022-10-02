package luckStar.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import luckStar.manager.LuckStarManager;
   
   public class LuckStarAwardView extends Sprite implements Disposeable
   {
       
      
      private var bg:Bitmap;
      
      private var _closeBtn:BaseButton;
      
      private var _list:Vector.<BaseCell>;
      
      private var _countList:Vector.<FilterFrameText>;
      
      public function LuckStarAwardView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._countList = new Vector.<FilterFrameText>();
         this.bg = ComponentFactory.Instance.creat("luckyStar.view.AwardListBG");
         this._closeBtn = ComponentFactory.Instance.creat("luckyStar.view.RankBtn");
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__onClose);
         addChild(this.bg);
         addChild(this._closeBtn);
         this.updateView();
      }
      
      private function updateView() : void
      {
         var _loc2_:Vector.<InventoryItemInfo> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:FilterFrameText = null;
         var _loc1_:Array = [11,12,13,14,15,16];
         _loc2_ = LuckStarManager.Instance.model.reward;
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         this._list = new Vector.<BaseCell>(_loc3_);
         while(_loc1_.length)
         {
            _loc5_ = _loc1_.shift();
            _loc4_ = 0;
            _loc6_ = 0;
            while(_loc6_ < _loc3_)
            {
               if(_loc2_[_loc6_].Quality == _loc5_)
               {
                  this._list[_loc6_] = new BaseCell(ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.awardcellBg"));
                  this._list[_loc6_].info = _loc2_[_loc6_];
                  this._list[_loc6_].info.Quality = ItemManager.Instance.getTemplateById(_loc2_[_loc6_].TemplateID).Quality;
                  PositionUtils.setPos(this._list[_loc6_],"luckyStar.view.awardPos" + _loc5_ + _loc4_);
                  addChild(this._list[_loc6_]);
                  if(_loc2_[_loc6_].Count > 1)
                  {
                     _loc7_ = ComponentFactory.Instance.creat("luckyStar.view.cellCount");
                     _loc7_.text = _loc2_[_loc6_].Count.toString();
                     _loc7_.x = this._list[_loc6_].x - 12;
                     _loc7_.y = this._list[_loc6_].y + 25;
                     addChild(_loc7_);
                     this._countList.push(_loc7_);
                  }
                  _loc4_++;
               }
               _loc6_++;
            }
         }
      }
      
      private function __onClose(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.parent.removeChild(this);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this.bg);
         this.bg = null;
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__onClose);
         ObjectUtils.disposeObject(this._closeBtn);
         this._closeBtn = null;
         while(this._list.length)
         {
            ObjectUtils.disposeObject(this._list.pop());
         }
         this._list = null;
         while(this._countList.length)
         {
            ObjectUtils.disposeObject(this._countList.pop());
         }
         this._countList = null;
      }
   }
}
