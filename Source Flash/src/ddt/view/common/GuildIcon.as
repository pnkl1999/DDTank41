package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.manager.PlayerManager;
   import ddt.view.tips.GuildIconTipInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class GuildIcon extends Sprite implements Disposeable, ITipedDisplay
   {
      
      public static const BIG:String = "big";
      
      public static const SMALL:String = "small";
       
      
      private var _icon:ScaleFrameImage;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _tipData:GuildIconTipInfo;
      
      private var _cid:int;
      
      private var _level:int;
      
      private var _repute:int;
      
      public function GuildIcon()
      {
         super();
         this._icon = ComponentFactory.Instance.creatComponentByStylename("asset.core.guildIcon");
         addChild(this._icon);
         this._icon.setFrame(1);
         this._tipStyle = "core.guildIconTip";
         this._tipGapV = 5;
         this._tipGapH = 5;
         this._tipDirctions = "7,6";
         ShowTipManager.Instance.addTip(this);
         this._tipData = new GuildIconTipInfo();
      }
      
      public function setInfo(param1:int, param2:int, param3:int) : void
      {
         this._cid = param2;
         this._level = param1;
         this._repute = param3;
         var _loc4_:int = PlayerManager.Instance.Self.ConsortiaID > 0 ? (param2 == PlayerManager.Instance.Self.ConsortiaID ? int(int(GuildIconTipInfo.MEMBER)) : int(int(GuildIconTipInfo.ENEMY))) : int(int(GuildIconTipInfo.NEUTRAL));
         this._icon.setFrame(_loc4_ == GuildIconTipInfo.ENEMY ? int(int(2)) : int(int(1)));
         this._tipData.Level = param1;
         this._tipData.State = _loc4_;
         this._tipData.Repute = param3;
      }
      
      public function set showTip(param1:Boolean) : void
      {
         if(param1)
         {
            ShowTipManager.Instance.addTip(this);
         }
         else
         {
            ShowTipManager.Instance.removeTip(this);
         }
      }
      
      public function set size(param1:String) : void
      {
         if(param1 == BIG)
         {
            this._icon.scaleX = this._icon.scaleY = 1;
         }
         else
         {
            this._icon.scaleX = this._icon.scaleY = 0.8;
         }
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         var _loc1_:int = PlayerManager.Instance.Self.ConsortiaID > 0 ? (this._cid == PlayerManager.Instance.Self.ConsortiaID ? int(int(GuildIconTipInfo.MEMBER)) : int(int(GuildIconTipInfo.ENEMY))) : int(int(GuildIconTipInfo.NEUTRAL));
         this._icon.setFrame(_loc1_ == GuildIconTipInfo.ENEMY ? int(int(2)) : int(int(1)));
         this._tipData.Level = this._level;
         this._tipData.State = _loc1_;
         this._tipData.Repute = this._repute;
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1 as GuildIconTipInfo;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this._icon.dispose();
         this._icon = null;
         ShowTipManager.Instance.removeTip(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
