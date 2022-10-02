package texpSystem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import texpSystem.controller.TexpManager;
   import texpSystem.data.TexpType;
   
   public class TexpInfoView extends Sprite implements Disposeable
   {
       
      
      private var _bg1:Scale9CornerImage;
      
      private var _bg2:Scale9CornerImage;
      
      private var _bg3:Scale9CornerImage;
      
      private var _bg4:Bitmap;
      
      private var _bg5:Bitmap;
      
      private var _txtBg1:Bitmap;
      
      private var _txtBg2:Bitmap;
      
      private var _txtBg3:Bitmap;
      
      private var _txtBg4:Bitmap;
      
      private var _txtBg5:Bitmap;
      
      private var _bmpHp:Bitmap;
      
      private var _bmpAtt:Bitmap;
      
      private var _bmpDef:Bitmap;
      
      private var _bmpSpd:Bitmap;
      
      private var _bmpLuk:Bitmap;
      
      private var _txtAttEff:FilterFrameText;
      
      private var _txtDefEff:FilterFrameText;
      
      private var _txtHpEff:FilterFrameText;
      
      private var _txtLukEff:FilterFrameText;
      
      private var _txtSpdEff:FilterFrameText;
      
      private var _btnHpIcon:BaseButton;
      
      private var _btnAttIcon:BaseButton;
      
      private var _btnDefIcon:BaseButton;
      
      private var _btnSpdIcon:BaseButton;
      
      private var _btnLukIcon:BaseButton;
      
      private var _info:PlayerInfo;
      
      public function TexpInfoView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("texpSystem.bg1");
         addChild(this._bg1);
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("texpSystem.bg2");
         addChild(this._bg2);
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("texpSystem.bg3");
         addChild(this._bg3);
         this._bg4 = ComponentFactory.Instance.creatBitmap("asset.texpSystem.bg4");
         addChild(this._bg4);
         this._bg5 = ComponentFactory.Instance.creatBitmap("asset.texpSystem.bg5");
         addChild(this._bg5);
         this._txtBg1 = ComponentFactory.Instance.creatBitmap("asset.texpSystem.infoTxtBg");
         PositionUtils.setPos(this._txtBg1,"texpSystem.posInfoTxtBg1");
         addChild(this._txtBg1);
         this._txtBg2 = ComponentFactory.Instance.creatBitmap("asset.texpSystem.infoTxtBg");
         PositionUtils.setPos(this._txtBg2,"texpSystem.posInfoTxtBg2");
         addChild(this._txtBg2);
         this._txtBg3 = ComponentFactory.Instance.creatBitmap("asset.texpSystem.infoTxtBg");
         PositionUtils.setPos(this._txtBg3,"texpSystem.posInfoTxtBg3");
         addChild(this._txtBg3);
         this._txtBg4 = ComponentFactory.Instance.creatBitmap("asset.texpSystem.infoTxtBg");
         PositionUtils.setPos(this._txtBg4,"texpSystem.posInfoTxtBg4");
         addChild(this._txtBg4);
         this._txtBg5 = ComponentFactory.Instance.creatBitmap("asset.texpSystem.infoTxtBg");
         PositionUtils.setPos(this._txtBg5,"texpSystem.posInfoTxtBg5");
         addChild(this._txtBg5);
         this._bmpHp = ComponentFactory.Instance.creatBitmap("asset.texpSystem.txtHp");
         addChild(this._bmpHp);
         this._bmpAtt = ComponentFactory.Instance.creatBitmap("asset.texpSystem.txtAtt");
         addChild(this._bmpAtt);
         this._bmpDef = ComponentFactory.Instance.creatBitmap("asset.texpSystem.txtDef");
         addChild(this._bmpDef);
         this._bmpSpd = ComponentFactory.Instance.creatBitmap("asset.texpSystem.txtSpd");
         addChild(this._bmpSpd);
         this._bmpLuk = ComponentFactory.Instance.creatBitmap("asset.texpSystem.txtLuk");
         addChild(this._bmpLuk);
         this._txtAttEff = ComponentFactory.Instance.creatComponentByStylename("texpSystem.txtAttEff");
         addChild(this._txtAttEff);
         this._txtDefEff = ComponentFactory.Instance.creatComponentByStylename("texpSystem.txtDefEff");
         addChild(this._txtDefEff);
         this._txtHpEff = ComponentFactory.Instance.creatComponentByStylename("texpSystem.txtHpEff");
         addChild(this._txtHpEff);
         this._txtLukEff = ComponentFactory.Instance.creatComponentByStylename("texpSystem.txtLukEff");
         addChild(this._txtLukEff);
         this._txtSpdEff = ComponentFactory.Instance.creatComponentByStylename("texpSystem.txtSpdEff");
         addChild(this._txtSpdEff);
         this._btnHpIcon = ComponentFactory.Instance.creatComponentByStylename("texpSystem.hp2");
         this._btnHpIcon.useHandCursor = false;
         addChild(this._btnHpIcon);
         this._btnAttIcon = ComponentFactory.Instance.creatComponentByStylename("texpSystem.att2");
         this._btnAttIcon.useHandCursor = false;
         addChild(this._btnAttIcon);
         this._btnDefIcon = ComponentFactory.Instance.creatComponentByStylename("texpSystem.def2");
         this._btnDefIcon.useHandCursor = false;
         addChild(this._btnDefIcon);
         this._btnSpdIcon = ComponentFactory.Instance.creatComponentByStylename("texpSystem.spd2");
         this._btnSpdIcon.useHandCursor = false;
         addChild(this._btnSpdIcon);
         this._btnLukIcon = ComponentFactory.Instance.creatComponentByStylename("texpSystem.luk2");
         this._btnLukIcon.useHandCursor = false;
         addChild(this._btnLukIcon);
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      private function getX(param1:FilterFrameText, param2:Bitmap) : Number
      {
         return param2.x + (param2.width - param1.width) / 2;
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         if(!param1)
         {
            return;
         }
         this._info = param1;
         this._txtAttEff.text = TexpManager.Instance.getInfo(TexpType.ATT,this._info.attTexpExp).currEffect.toString();
         this._txtAttEff.x = this.getX(this._txtAttEff,this._txtBg1);
         this._txtDefEff.text = TexpManager.Instance.getInfo(TexpType.DEF,this._info.defTexpExp).currEffect.toString();
         this._txtDefEff.x = this.getX(this._txtDefEff,this._txtBg2);
         this._txtHpEff.text = TexpManager.Instance.getInfo(TexpType.HP,this._info.hpTexpExp).currEffect.toString();
         this._txtHpEff.x = this.getX(this._txtHpEff,this._txtBg3);
         this._txtLukEff.text = TexpManager.Instance.getInfo(TexpType.LUK,this._info.lukTexpExp).currEffect.toString();
         this._txtLukEff.x = this.getX(this._txtLukEff,this._txtBg4);
         this._txtSpdEff.text = TexpManager.Instance.getInfo(TexpType.SPD,this._info.spdTexpExp).currEffect.toString();
         this._txtSpdEff.x = this.getX(this._txtSpdEff,this._txtBg5);
         this._btnHpIcon.tipData = TexpManager.Instance.getInfo(TexpType.HP,this._info.hpTexpExp);
         this._btnAttIcon.tipData = TexpManager.Instance.getInfo(TexpType.ATT,this._info.attTexpExp);
         this._btnDefIcon.tipData = TexpManager.Instance.getInfo(TexpType.DEF,this._info.defTexpExp);
         this._btnSpdIcon.tipData = TexpManager.Instance.getInfo(TexpType.SPD,this._info.spdTexpExp);
         this._btnLukIcon.tipData = TexpManager.Instance.getInfo(TexpType.LUK,this._info.lukTexpExp);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg1 = null;
         this._bg2 = null;
         this._bg3 = null;
         this._bg4 = null;
         this._bg5 = null;
         this._txtBg1 = null;
         this._txtBg2 = null;
         this._txtBg3 = null;
         this._txtBg4 = null;
         this._txtBg5 = null;
         this._bmpHp = null;
         this._bmpAtt = null;
         this._bmpDef = null;
         this._bmpSpd = null;
         this._bmpLuk = null;
         this._txtAttEff = null;
         this._txtDefEff = null;
         this._txtHpEff = null;
         this._txtLukEff = null;
         this._txtSpdEff = null;
         this._btnHpIcon = null;
         this._btnAttIcon = null;
         this._btnDefIcon = null;
         this._btnSpdIcon = null;
         this._btnLukIcon = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
