package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import totem.TotemManager;
   
   public class TotemInfoView extends Sprite implements Disposeable
   {
       
      
      private var _windowView:TotemLeftWindowView;
      
      private var _levelBg:Bitmap;
      
      private var _level:FilterFrameText;
      
      private var _txtBg:Bitmap;
      
      private var _propertyList:Vector.<TotemInfoViewTxtCell>;
      
      private var _info:PlayerInfo;
      
      public function TotemInfoView(param1:PlayerInfo)
      {
         super();
         this._info = param1;
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TotemInfoViewTxtCell = null;
         _loc1_ = 0;
         _loc2_ = null;
         _loc1_ = 0;
         _loc2_ = null;
         _loc1_ = 0;
         _loc2_ = null;
         this._windowView = ComponentFactory.Instance.creatCustomObject("totemInfoWindowView");
         this._windowView.show(TotemManager.instance.getCurInfoById(this._info.totemId).Page,TotemManager.instance.getNextInfoById(this._info.totemId),false);
         this._windowView.scaleX = 435 / 549;
         this._windowView.scaleY = 435 / 549;
         this._windowView.scalePropertyTxtSprite(549 / 435);
         this._levelBg = ComponentFactory.Instance.creatBitmap("asset.totem.infoView.levelBg");
         this._level = ComponentFactory.Instance.creatComponentByStylename("totem.infoView.level.txt");
         this._txtBg = ComponentFactory.Instance.creatBitmap("asset.totem.infoView.txtBg");
         addChild(this._windowView);
         addChild(this._levelBg);
         addChild(this._level);
         this._level.text = TotemManager.instance.getCurrentLv(TotemManager.instance.getTotemPointLevel(this._info.totemId)).toString();
         addChild(this._txtBg);
         this._propertyList = new Vector.<TotemInfoViewTxtCell>();
         _loc1_ = 1;
         while(_loc1_ <= 7)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("TotemInfoViewTxtCell" + _loc1_);
            _loc2_.show(_loc1_,TotemManager.instance.getTotemPointLevel(this._info.totemId));
            addChild(_loc2_);
            this._propertyList.push(_loc2_);
            _loc2_.x = this._propertyList[0].x + (_loc1_ - 1) % 4 * 104;
            _loc2_.y = this._propertyList[0].y + int((_loc1_ - 1) / 4) * 32;
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._windowView = null;
         this._levelBg = null;
         this._level = null;
         this._txtBg = null;
         this._propertyList = null;
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
