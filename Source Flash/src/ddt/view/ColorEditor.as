package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.ColorEnum;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Event(name="change",type="flash.events.Event")]
   public class ColorEditor extends Sprite implements Disposeable
   {
      
      public static const REDUCTIVE_COLOR:String = "reductiveColor";
       
      
      private var _colors:Array;
      
      private var _skins:Array;
      
      private var _colorsArr:Array;
      
      private var _skinsArr:Array;
      
      private var _colorlist:SimpleTileList;
      
      private var _skincolorlist:SimpleTileList;
      
      private var _colorBtn:SelectedButton;
      
      private var _textureBtn:SelectedButton;
      
      private var _restoreColorBtn:BaseButton;
      
      private var _colorPanelMask:Bitmap;
      
      private var _colorPanelBg:Bitmap;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _ciGroup:SelectedButtonGroup;
      
      private var _siGroup:SelectedButtonGroup;
      
      private var _colorRestorable:Boolean;
      
      private var _skinRestorable:Boolean;
      
      private var _selectedColor:int;
      
      private var _selectedSkin:int;
      
      public function ColorEditor()
      {
         super();
         this._selectedColor = -1;
         this._selectedSkin = -1;
         this._btnGroup = new SelectedButtonGroup();
         this._colorBtn = ComponentFactory.Instance.creatComponentByStylename("shop.ColorBtn");
         this._textureBtn = ComponentFactory.Instance.creatComponentByStylename("shop.TextureBtn");
         this._restoreColorBtn = ComponentFactory.Instance.creatComponentByStylename("shop.ReductiveColorBtn");
         this._colorPanelBg = ComponentFactory.Instance.creatBitmap("asset.shop.ColorChoosePanel");
         this._colorPanelMask = ComponentFactory.Instance.creatBitmap("asset.shop.ColorMask");
         this._colors = ColorEnum.COLORS;
         this._skins = ColorEnum.SKIN_COLORS;
         this._colorsArr = new Array();
         this._skinsArr = new Array();
         this._colorlist = new SimpleTileList(14);
         this._skincolorlist = new SimpleTileList(14);
         this._colorlist.vSpace = this._colorlist.hSpace = this._skincolorlist.vSpace = this._skincolorlist.hSpace = 1;
         this._btnGroup.addSelectItem(this._colorBtn);
         this._btnGroup.addSelectItem(this._textureBtn);
         PositionUtils.setPos(this._colorlist,"shop.ColorPanelPos");
         PositionUtils.setPos(this._skincolorlist,"shop.ColorPanelPos");
         addChild(this._colorPanelBg);
         addChild(this._colorBtn);
         addChild(this._textureBtn);
         addChild(this._restoreColorBtn);
         addChild(this._colorlist);
         addChild(this._skincolorlist);
         this._colorBtn.addEventListener(MouseEvent.CLICK,this.__colorEditClick);
         this._textureBtn.addEventListener(MouseEvent.CLICK,this.__skinEditClick);
         this._restoreColorBtn.addEventListener(MouseEvent.CLICK,this.__restoreColorBtnClick);
         this.colorEditable = true;
         this.skinEditable = false;
         this._ciGroup = new SelectedButtonGroup(true);
         this._siGroup = new SelectedButtonGroup(true);
         this.initColors();
         addChild(this._colorPanelMask);
      }
      
      private function initColors() : void
      {
         var _loc3_:ColorItem = null;
         var _loc4_:ColorItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._colors.length)
         {
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("shop.ColorItem");
            _loc3_.setup(this._colors[_loc1_]);
            this._colorsArr.push(_loc3_);
            this._colorlist.addChild(_loc3_);
            this._ciGroup.addSelectItem(_loc3_);
            _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.__colorItemClick);
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._skins.length)
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("shop.ColorItem");
            _loc4_.setup(this._skins[_loc2_]);
            this._skinsArr.push(_loc4_);
            this._skincolorlist.addChild(_loc4_);
            this._siGroup.addSelectItem(_loc4_);
            _loc4_.addEventListener(MouseEvent.MOUSE_DOWN,this.__skinItemClick);
            _loc2_++;
         }
      }
      
      public function reset() : void
      {
         this._selectedColor = -1;
         this._selectedSkin = -1;
         this._ciGroup.selectIndex = -1;
         this._siGroup.selectIndex = -1;
         this._colorRestorable = false;
         this._skinRestorable = false;
      }
      
      public function get colorRestorable() : Boolean
      {
         return this._colorRestorable;
      }
      
      public function set colorRestorable(param1:Boolean) : void
      {
         this._colorRestorable = param1;
         if(this.colorEditable && this.selectedType == 1)
         {
            this._restoreColorBtn.enable = this._colorRestorable;
         }
      }
      
      public function get skinRestorable() : Boolean
      {
         return this._skinRestorable;
      }
      
      public function set skinRestorable(param1:Boolean) : void
      {
         this._skinRestorable = param1;
         if(this.skinEditable && this.selectedType == 2)
         {
            this._restoreColorBtn.enable = this._skinRestorable;
         }
      }
      
      public function set restorable(param1:Boolean) : void
      {
         this._restoreColorBtn.visible = param1;
      }
      
      public function get colorEditable() : Boolean
      {
         return this._colorBtn.enable;
      }
      
      public function set colorEditable(param1:Boolean) : void
      {
         if(this._colorBtn.enable != param1)
         {
            this._colorBtn.enable = param1;
            if(!param1 && this._colorlist.visible)
            {
               this._colorlist.visible = false;
               this._colorPanelMask.visible = true;
            }
         }
         this.updateReductiveColorBtn();
      }
      
      public function get skinEditable() : Boolean
      {
         return this._textureBtn.enable;
      }
      
      public function set skinEditable(param1:Boolean) : void
      {
         if(this._textureBtn.enable != param1)
         {
            this._textureBtn.enable = param1;
            if(!param1 && this._skincolorlist.visible)
            {
               this._skincolorlist.visible = false;
               this._colorPanelMask.visible = true;
            }
         }
         this.updateReductiveColorBtn();
      }
      
      private function updateReductiveColorBtn() : void
      {
         if(!this.colorEditable && !this.skinEditable)
         {
            this._restoreColorBtn.enable = false;
         }
         else
         {
            this._restoreColorBtn.enable = true;
         }
      }
      
      public function editColor(param1:int = -1) : void
      {
         if(this.colorEditable)
         {
            this.selectedColor = param1;
            this._colorlist.visible = true;
            this._restoreColorBtn.enable = this._selectedColor != -1 || this._colorRestorable;
            this._skincolorlist.visible = false;
            this._colorPanelMask.visible = false;
            if(param1 == -1)
            {
               this._ciGroup.selectIndex = -1;
            }
         }
      }
      
      public function editSkin(param1:int = -1) : void
      {
         if(this.skinEditable)
         {
            this.selectedSkin = param1;
            this._colorlist.visible = false;
            this._restoreColorBtn.enable = this._selectedSkin != -1 || this._skinRestorable;
            this._skincolorlist.visible = true;
            this._colorPanelMask.visible = false;
            if(param1 == -1)
            {
               this._siGroup.selectIndex = -1;
            }
         }
      }
      
      public function get selectedType() : int
      {
         return this._btnGroup.selectIndex + 1;
      }
      
      public function set selectedType(param1:int) : void
      {
         this._btnGroup.selectIndex = param1 - 1;
         if(this._btnGroup.selectIndex)
         {
            this.editColor(this.selectedColor);
         }
         else
         {
            this.editSkin(this.selectedSkin);
         }
      }
      
      public function get selectedColor() : int
      {
         return this._selectedColor;
      }
      
      public function set selectedColor(param1:int) : void
      {
         if(param1 != this._selectedColor && this.colorEditable)
         {
            this._selectedColor = param1;
            this._colorlist.selectedIndex = this._colors.indexOf(param1);
            this.updateReductiveColorBtn();
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get selectedSkin() : int
      {
         return this._selectedSkin;
      }
      
      public function set selectedSkin(param1:int) : void
      {
         if(param1 != this._selectedSkin && this.skinEditable)
         {
            this._selectedSkin = param1;
            this._skincolorlist.selectedIndex = this._skins.indexOf(param1);
            this.updateReductiveColorBtn();
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function resetColor() : void
      {
         this._selectedColor = -1;
         this._colorRestorable = false;
      }
      
      public function resetSkin() : void
      {
         this._selectedSkin = -1;
         this._skinRestorable = false;
         this._skincolorlist.selectedIndex = this._skins.indexOf(this._selectedSkin);
      }
      
      private function __colorItemClick(param1:Event) : void
      {
         SoundManager.instance.play("047");
         var _loc2_:ColorItem = param1.currentTarget as ColorItem;
         this.selectedColor = _loc2_.getColor();
      }
      
      private function __skinItemClick(param1:Event) : void
      {
         SoundManager.instance.play("047");
         var _loc2_:ColorItem = param1.currentTarget as ColorItem;
         this.selectedSkin = _loc2_.getColor();
      }
      
      private function __colorEditClick(param1:Event) : void
      {
         SoundManager.instance.play("047");
         this.editColor(this.selectedColor);
      }
      
      private function __skinEditClick(param1:Event) : void
      {
         SoundManager.instance.play("047");
         this.editSkin(this.selectedSkin);
      }
      
      protected function __restoreColorBtnClick(param1:MouseEvent) : void
      {
         if(this.selectedType == 1)
         {
            this.resetColor();
         }
         else
         {
            this.resetSkin();
         }
         this._restoreColorBtn.enable = false;
         SoundManager.instance.play("008");
         dispatchEvent(new Event(REDUCTIVE_COLOR));
      }
      
      public function dispose() : void
      {
         this._colorBtn.removeEventListener(MouseEvent.CLICK,this.__colorEditClick);
         this._textureBtn.removeEventListener(MouseEvent.CLICK,this.__skinEditClick);
         this._restoreColorBtn.removeEventListener(MouseEvent.CLICK,this.__restoreColorBtnClick);
         this._colorBtn = null;
         this._textureBtn = null;
         this._restoreColorBtn = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._colors.length)
         {
            this._colorsArr[_loc1_].removeEventListener(MouseEvent.MOUSE_DOWN,this.__colorItemClick);
            this._colorsArr[_loc1_].dispose();
            this._colorsArr[_loc1_] = null;
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._skinsArr.length)
         {
            this._skinsArr[_loc2_].removeEventListener(MouseEvent.MOUSE_DOWN,this.__skinItemClick);
            this._skinsArr[_loc2_].dispose();
            this._skinsArr[_loc2_] = null;
            _loc2_++;
         }
         if(this._colorlist)
         {
            if(this._colorlist.parent)
            {
               this._colorlist.parent.removeChild(this._colorlist);
            }
            this._colorlist.disposeAllChildren();
         }
         this._colorlist = null;
         if(this._skincolorlist)
         {
            if(this._skincolorlist.parent)
            {
               this._skincolorlist.parent.removeChild(this._skincolorlist);
            }
            this._skincolorlist.disposeAllChildren();
         }
         this._skincolorlist = null;
         this._colors = null;
         this._skins = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
