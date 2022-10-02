package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.text.TextFormat;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemPointTipView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _propertyNameTxt:FilterFrameText;
      
      private var _propertyValueTxt:FilterFrameText;
      
      private var _propertyValueList:Array;
      
      private var _possibleValeList:Array;
      
      private var _propertyValueTextFormatList:Vector.<TextFormat>;
      
      private var _propertyValueGlowFilterList:Vector.<GlowFilter>;
      
      private var _possibleValueTxtColorList:Array;
      
      private var _honorExpSprite:Sprite;
      
      private var _honorTxt:FilterFrameText;
      
      private var _expTxt:FilterFrameText;
      
      private var _lvAddPropertyTxtSprite:Sprite;
      
      private var _lvAddPropertyTxtList:Vector.<FilterFrameText>;
      
      private var _bg2:Bitmap;
      
      private var _statusNameTxt:FilterFrameText;
      
      private var _statusValueTxt:FilterFrameText;
      
      private var _currentPropertyTxt:FilterFrameText;
      
      private var _statusValueList:Array;
      
      public function TotemPointTipView()
      {
         this._possibleValueTxtColorList = [16752450,9634815,35314,9035310,16727331];
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.initData();
         this.initView();
      }
      
      private function initData() : void
      {
         this._propertyValueTextFormatList = new Vector.<TextFormat>();
         this._propertyValueGlowFilterList = new Vector.<GlowFilter>();
         var _loc1_:int = 1;
         while(_loc1_ <= 7)
         {
            this._propertyValueTextFormatList.push(ComponentFactory.Instance.model.getSet("totem.totemWindow.propertyName" + _loc1_ + ".tf"));
            this._propertyValueGlowFilterList.push(ComponentFactory.Instance.model.getSet("totem.totemWindow.propertyName" + _loc1_ + ".gf"));
            _loc1_++;
         }
         this._propertyValueList = LanguageMgr.GetTranslation("ddt.totem.sevenProperty").split(",");
         this._possibleValeList = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.possibleValueTxt").split(",");
         this._statusValueList = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.statusValueTxt").split(",");
      }
      
      private function initView() : void
      {
         var _loc1_:FilterFrameText = null;
         var _loc2_:int = 0;
         _loc1_ = null;
         _loc2_ = 0;
         _loc1_ = null;
         _loc2_ = 0;
         _loc1_ = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.leftView.tipBg");
         this._propertyNameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.propertyNameTxt");
         this._propertyNameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.propertyNameTxt");
         this._propertyValueTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.propertyValueTxt");
         this._honorExpSprite = ComponentFactory.Instance.creatCustomObject("totem.totemPointTip.honorExpSprite");
         this._honorTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.honor");
         this._expTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.exp");
         this._honorExpSprite.addChild(this._honorTxt);
         this._honorExpSprite.addChild(this._expTxt);
         this._lvAddPropertyTxtSprite = ComponentFactory.Instance.creatCustomObject("totem.totemPointTip.lvAddPropertySprite");
         this._lvAddPropertyTxtList = new Vector.<FilterFrameText>();
         _loc2_ = 0;
         while(_loc2_ < 10)
         {
            _loc1_ = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.lvAddProperty");
            _loc1_.x = _loc2_ % 2 * 100;
            _loc1_.y = int(_loc2_ / 2) * 18;
            this._lvAddPropertyTxtSprite.addChild(_loc1_);
            this._lvAddPropertyTxtList.push(_loc1_);
            _loc2_++;
         }
         this._bg2 = ComponentFactory.Instance.creatBitmap("asset.totem.leftView.tipBg2");
         this._statusNameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.statusNameTxt");
         this._statusNameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.statusNameTxt");
         this._statusValueTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.statusValueTxt");
         this._currentPropertyTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.currentPropertyTxt");
         this._currentPropertyTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.currentPropertyTxt");
         addChild(this._bg);
         addChild(this._bg2);
         addChild(this._propertyNameTxt);
         addChild(this._propertyValueTxt);
         addChild(this._statusNameTxt);
         addChild(this._statusValueTxt);
         addChild(this._honorExpSprite);
         addChild(this._lvAddPropertyTxtSprite);
         addChild(this._currentPropertyTxt);
      }
      
      public function show(param1:TotemDataVo, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TotemDataVo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         if(param2)
         {
            this.showStatus1();
         }
         else
         {
            this.showStatus2();
         }
         var _loc10_:int = param1.Location - 1;
         var _loc11_:int = this.getValueByIndex(_loc10_,param1);
         this._propertyValueTxt.text = this._propertyValueList[_loc10_] + "+" + _loc11_;
         this._propertyValueTxt.setTextFormat(this._propertyValueTextFormatList[_loc10_]);
         this._propertyValueTxt.filters = [this._propertyValueGlowFilterList[_loc10_]];
         if(param2)
         {
            _loc4_ = param1.Random;
            if(_loc4_ >= 100)
            {
               _loc10_ = 0;
            }
            else if(_loc4_ >= 80 && _loc4_ < 100)
            {
               _loc10_ = 1;
            }
            else if(_loc4_ >= 40 && _loc4_ < 80)
            {
               _loc10_ = 2;
            }
            else if(_loc4_ >= 20 && _loc4_ < 40)
            {
               _loc10_ = 3;
            }
            else
            {
               _loc10_ = 4;
            }
            this._honorTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.honorTxt",param1.ConsumeHonor);
            this._expTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.expTxt",param1.ConsumeExp);
            if(PlayerManager.Instance.Self.myHonor < param1.ConsumeHonor)
            {
               this._honorTxt.setTextFormat(new TextFormat(null,null,16711680));
            }
            if(TotemManager.instance.usableGP < param1.ConsumeExp)
            {
               this._expTxt.setTextFormat(new TextFormat(null,null,16711680));
            }
         }
         else if(param3)
         {
            this._statusValueTxt.text = this._statusValueList[0];
            this._statusValueTxt.setTextFormat(new TextFormat(null,null,15728384));
         }
         else
         {
            this._statusValueTxt.text = this._statusValueList[1];
            this._statusValueTxt.setTextFormat(new TextFormat(null,null,9408399));
         }
         var _loc12_:int = param1.Page;
         var _loc13_:int = param1.Location;
         var _loc14_:Array = TotemManager.instance.getSamePageLocationList(_loc12_,_loc13_);
         var _loc15_:int = _loc14_.length;
         var _loc16_:int = param1.Layers - 1;
         var _loc17_:int = param1.Layers;
         var _loc18_:int = 0;
         while(_loc18_ < _loc15_)
         {
            _loc5_ = _loc14_[_loc18_] as TotemDataVo;
            _loc6_ = (_loc12_ - 1) * 10 + _loc5_.Layers;
            _loc7_ = _loc5_.Location - 1;
            _loc8_ = this._propertyValueList[_loc7_];
            _loc9_ = this.getValueByIndex(_loc7_,_loc5_);
            this._lvAddPropertyTxtList[_loc18_].text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.lvAddPropertyTxt",_loc6_,_loc8_,_loc9_);
            this._lvAddPropertyTxtList[_loc18_].setTextFormat(this._propertyValueTextFormatList[_loc10_]);
            if(param3 && _loc5_.Layers <= _loc17_ || !param3 && _loc5_.Layers <= _loc16_)
            {
               this._lvAddPropertyTxtList[_loc18_].setTextFormat(new TextFormat(null,null,null,false));
               this._lvAddPropertyTxtList[_loc18_].filters = [this._propertyValueGlowFilterList[_loc10_]];
            }
            else
            {
               this._lvAddPropertyTxtList[_loc18_].setTextFormat(new TextFormat(null,null,11842740,false));
            }
            _loc18_++;
         }
         if(param2)
         {
            PositionUtils.setPos(this._lvAddPropertyTxtSprite,"totem.totemPointTip.lvAddPropertySpritePos1");
         }
         else
         {
            PositionUtils.setPos(this._lvAddPropertyTxtSprite,"totem.totemPointTip.lvAddPropertySpritePos2");
         }
      }
      
      private function showStatus1() : void
      {
         this._bg.visible = true;
         this._bg2.visible = false;
         this._propertyNameTxt.visible = true;
         this._propertyValueTxt.visible = true;
         this._statusNameTxt.visible = false;
         this._statusValueTxt.visible = false;
         this._honorExpSprite.visible = true;
         this._lvAddPropertyTxtSprite.visible = true;
         this._currentPropertyTxt.visible = false;
      }
      
      private function showStatus2() : void
      {
         this._bg.visible = false;
         this._bg2.visible = true;
         this._propertyNameTxt.visible = true;
         this._propertyValueTxt.visible = true;
         this._statusNameTxt.visible = true;
         this._statusValueTxt.visible = true;
         this._honorExpSprite.visible = false;
         this._lvAddPropertyTxtSprite.visible = true;
         this._currentPropertyTxt.visible = true;
      }
      
      public function getValueByIndex(param1:int, param2:TotemDataVo) : int
      {
         var _loc3_:int = 0;
         switch(param1)
         {
            case 0:
               _loc3_ = param2.AddAttack;
               break;
            case 1:
               _loc3_ = param2.AddDefence;
               break;
            case 2:
               _loc3_ = param2.AddAgility;
               break;
            case 3:
               _loc3_ = param2.AddLuck;
               break;
            case 4:
               _loc3_ = param2.AddBlood;
               break;
            case 5:
               _loc3_ = param2.AddDamage;
               break;
            case 6:
               _loc3_ = param2.AddGuard;
               break;
            default:
               _loc3_ = 0;
         }
         return _loc3_;
      }
      
      public function dispose() : void
      {
         var _loc1_:FilterFrameText = null;
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._propertyNameTxt = null;
         this._propertyValueTxt = null;
         this._propertyValueList = null;
         this._possibleValeList = null;
         this._propertyValueTextFormatList = null;
         this._propertyValueGlowFilterList = null;
         ObjectUtils.disposeObject(this._honorTxt);
         this._honorTxt = null;
         ObjectUtils.disposeObject(this._expTxt);
         this._expTxt = null;
         this._honorExpSprite = null;
         for each(_loc1_ in this._lvAddPropertyTxtList)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         this._lvAddPropertyTxtList = null;
         this._lvAddPropertyTxtSprite = null;
         this._bg2 = null;
         this._statusNameTxt = null;
         this._statusValueTxt = null;
         this._currentPropertyTxt = null;
         this._statusValueList = null;
         this._possibleValueTxtColorList = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
