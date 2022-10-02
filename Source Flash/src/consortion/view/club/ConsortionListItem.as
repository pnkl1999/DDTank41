package consortion.view.club
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.data.ConsortiaInfo;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ConsortionListItem extends Sprite implements Disposeable
   {
      
      private static var ITEM_LIGHT_WIDTH:int = 480;
      
      private static var ITEM_HEIGHT:int = 30;
       
      
      private var _info:ConsortiaInfo;
      
      private var _selected:Boolean;
      
      private var _consortionName:FilterFrameText;
      
      private var _chairMan:FilterFrameText;
      
      private var _count:FilterFrameText;
      
      private var _level:FilterFrameText;
      
      private var _exploit:FilterFrameText;
      
      private var _light:Bitmap;
      
      private var _badge:Badge;
      
      public function ConsortionListItem()
      {
         super();
         this.init();
      }
      
      override public function get height() : Number
      {
         return ITEM_HEIGHT;
      }
      
      override public function get width() : Number
      {
         return ITEM_LIGHT_WIDTH;
      }
      
      private function init() : void
      {
         this._badge = new Badge();
         this._consortionName = ComponentFactory.Instance.creatComponentByStylename("club.consortionName");
         this._chairMan = ComponentFactory.Instance.creatComponentByStylename("club.chairMan");
         this._count = ComponentFactory.Instance.creatComponentByStylename("club.count");
         this._level = ComponentFactory.Instance.creatComponentByStylename("club.level");
         this._exploit = ComponentFactory.Instance.creatComponentByStylename("club.exploit");
         this._light = ComponentFactory.Instance.creatBitmap("asset.club.Itemlight");
         this._light.visible = false;
         addChild(this._badge);
         addChild(this._consortionName);
         addChild(this._chairMan);
         addChild(this._count);
         addChild(this._level);
         addChild(this._exploit);
         addChild(this._light);
         PositionUtils.setPos(this._badge,"consortionClubItem.badge.pos");
      }
      
      public function set info(param1:ConsortiaInfo) : void
      {
         if(this._info == param1)
         {
            return;
         }
         this._info = param1;
         this._badge.badgeID = this._info.BadgeID;
         this._badge.visible = this._info.BadgeID > 0;
         this._consortionName.text = String(param1.ConsortiaName);
         this._chairMan.text = String(param1.ChairmanName);
         this._count.text = String(param1.Count);
         this._level.text = String(param1.Level);
         this._exploit.text = String(param1.Honor);
      }
      
      public function get info() : ConsortiaInfo
      {
         return this._info;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         this._light.visible = this._selected;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set light(param1:Boolean) : void
      {
         if(this._selected)
         {
            return;
         }
         this._light.visible = param1;
      }
      
      public function set isApply(param1:Boolean) : void
      {
         if(param1)
         {
            alpha = 0.5;
            mouseChildren = false;
            mouseEnabled = false;
            this._light.visible = false;
         }
         else
         {
            alpha = 1;
            mouseChildren = true;
            mouseEnabled = true;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._consortionName = null;
         this._chairMan = null;
         this._count = null;
         this._level = null;
         this._exploit = null;
         this._light = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
