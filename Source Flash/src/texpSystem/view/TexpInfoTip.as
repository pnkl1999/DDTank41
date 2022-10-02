package texpSystem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import texpSystem.controller.TexpManager;
   import texpSystem.data.TexpInfo;
   import texpSystem.data.TexpType;
   
   public class TexpInfoTip extends Sprite implements ITransformableTip, Disposeable
   {
       
      
      private const NAME_COLOR:Array = ["#24e198","#f33232","#36baff","#69e000","#ffae00"];
      
      private var _bg:ScaleBitmapImage;
      
      private var _line:ScaleBitmapImage;
      
      private var _txtTitle:FilterFrameText;
      
      private var _txtContent:FilterFrameText;
      
      private var _tipWidth:int;
      
      private var _tipHeight:int;
      
      private var _tipData:PlayerInfo;
      
      public function TexpInfoTip()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("texpSystem.texpInfoTip.bg");
         this._line = ComponentFactory.Instance.creatComponentByStylename("texpSystem.texpInfoTip.line");
         this._txtTitle = ComponentFactory.Instance.creatComponentByStylename("texpSystem.texpInfoTip.title");
         this._txtContent = ComponentFactory.Instance.creatComponentByStylename("texpSystem.texpInfoTip.content");
         this._txtTitle.text = LanguageMgr.GetTranslation("texpSystem.view.TexpInfoTip.title");
         addChild(this._bg);
         addChild(this._line);
         addChild(this._txtTitle);
         addChild(this._txtContent);
      }
      
      public function get tipWidth() : int
      {
         return this._tipWidth;
      }
      
      public function set tipWidth(param1:int) : void
      {
         this._tipWidth = param1;
      }
      
      public function get tipHeight() : int
      {
         return this._tipHeight;
      }
      
      public function set tipHeight(param1:int) : void
      {
         this._tipHeight = param1;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         var _loc2_:PlayerInfo = param1 as PlayerInfo;
         if(!_loc2_)
         {
            return;
         }
         this._tipData = _loc2_;
         this._txtContent.htmlText = this.getHtmlText(TexpManager.Instance.getInfo(TexpType.ATT,this._tipData.attTexpExp)) + "\n" + this.getHtmlText(TexpManager.Instance.getInfo(TexpType.DEF,this._tipData.defTexpExp)) + "\n" + this.getHtmlText(TexpManager.Instance.getInfo(TexpType.SPD,this._tipData.spdTexpExp)) + "\n" + this.getHtmlText(TexpManager.Instance.getInfo(TexpType.LUK,this._tipData.lukTexpExp)) + "\n" + this.getHtmlText(TexpManager.Instance.getInfo(TexpType.HP,this._tipData.hpTexpExp));
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      private function getHtmlText(param1:TexpInfo) : String
      {
         return LanguageMgr.GetTranslation("texpSystem.view.TexpInfoTip.content",this.NAME_COLOR[param1.type],TexpManager.Instance.getName(param1.type),param1.currEffect,param1.lv);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._line = null;
         this._txtTitle = null;
         this._txtContent = null;
         this._tipData = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
