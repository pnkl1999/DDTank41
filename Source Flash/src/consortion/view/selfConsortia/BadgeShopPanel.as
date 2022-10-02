package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.BadgeInfoManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BadgeShopPanel extends Sprite implements Disposeable
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _levelBtn1:SelectedButton;
      
      private var _levelBtn2:SelectedButton;
      
      private var _levelBtn3:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _list:BadgeShopList;
      
      public function BadgeShopPanel()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.shopBadge.bg");
         addChild(this._bg);
         this._levelBtn1 = ComponentFactory.Instance.creatComponentByStylename("consortion.levelBtn1");
         this._levelBtn2 = ComponentFactory.Instance.creatComponentByStylename("consortion.levelBtn2");
         this._levelBtn3 = ComponentFactory.Instance.creatComponentByStylename("consortion.levelBtn3");
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._levelBtn1);
         this._btnGroup.addSelectItem(this._levelBtn2);
         this._btnGroup.addSelectItem(this._levelBtn3);
         this._btnGroup.selectIndex = 0;
         this._levelBtn1.displacement = this._levelBtn2.displacement = this._levelBtn3.displacement = false;
         addChild(this._levelBtn1);
         addChild(this._levelBtn2);
         addChild(this._levelBtn3);
         this._list = new BadgeShopList();
         this._list.setList(BadgeInfoManager.instance.getBadgeInfoByLevel(1,3));
         PositionUtils.setPos(this._list,"consortiaBadgeList.pos");
         addChild(this._list);
         this._btnGroup.addEventListener(Event.CHANGE,this.onSelectChange);
      }
      
      private function onSelectChange(param1:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._list.setList(BadgeInfoManager.instance.getBadgeInfoByLevel(1,3));
               break;
            case 1:
               this._list.setList(BadgeInfoManager.instance.getBadgeInfoByLevel(4,7));
               break;
            case 2:
               this._list.setList(BadgeInfoManager.instance.getBadgeInfoByLevel(8,10));
               break;
            default:
               this._list.setList(BadgeInfoManager.instance.getBadgeInfoByLevel(1,3));
         }
         SoundManager.instance.playButtonSound();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._levelBtn1);
         this._levelBtn1 = null;
         ObjectUtils.disposeObject(this._levelBtn2);
         this._levelBtn2 = null;
         ObjectUtils.disposeObject(this._levelBtn3);
         this._levelBtn3 = null;
         ObjectUtils.disposeObject(this._btnGroup);
         this._btnGroup = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
