package com.pickgliss.utils
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   public final class ObjectUtils
   {
      
      private static var _copyAbleTypes:Vector.<String>;
      
      private static var _descriptOjbXMLs:Dictionary;
       
      
      public function ObjectUtils()
      {
         super();
      }
      
      public static function cloneSimpleObject(param1:Object) : Object
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_.readObject();
      }
      
      public static function copyPorpertiesByXML(param1:Object, param2:XML) : void
      {
         var item:XML = null;
         var propname:String = null;
         var value:String = null;
         var object:Object = param1;
         var data:XML = param2;
         var attr:XMLList = data.attributes();
         for each(item in attr)
         {
            propname = item.name().toString();
            if(object.hasOwnProperty(propname))
            {
               try
               {
                  value = item.toString();
                  if(value == "false")
                  {
                     object[propname] = false;
                  }
                  else
                  {
                     object[propname] = value;
                  }
               }
               catch(e:Error)
               {
                  continue;
               }
            }
         }
      }
      
      public static function copyProperties(param1:Object, param2:Object) : void
      {
         var _loc4_:XMLList = null;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         if(_descriptOjbXMLs == null)
         {
            _descriptOjbXMLs = new Dictionary();
         }
         var _loc3_:Vector.<String> = getCopyAbleType();
         var _loc5_:XML = describeTypeSave(param2);
         _loc4_ = _loc5_.variable;
         for each(_loc6_ in _loc4_)
         {
            _loc8_ = _loc6_.@type;
            if(_loc3_.indexOf(_loc8_) != -1)
            {
               _loc9_ = _loc6_.@name;
               if(param1.hasOwnProperty(_loc9_))
               {
                  param1[_loc9_] = param2[_loc9_];
               }
            }
         }
         _loc4_ = _loc5_.accessor;
         for each(_loc7_ in _loc4_)
         {
            _loc10_ = _loc7_.@type;
            if(_loc3_.indexOf(_loc10_) != -1)
            {
               _loc11_ = _loc7_.@name;
               try
               {
                  param1[_loc11_] = param2[_loc11_];
               }
               catch(err:Error)
               {
               }
            }
         }
      }
      
      public static function disposeAllChildren(param1:DisplayObjectContainer) : void
      {
         var _loc2_:DisplayObject = null;
         if(param1 == null)
         {
            return;
         }
         while(param1.numChildren > 0)
         {
            _loc2_ = param1.getChildAt(0);
            ObjectUtils.disposeObject(_loc2_);
         }
      }
      
      public static function removeChildAllChildren(param1:DisplayObjectContainer) : void
      {
         while(param1.numChildren > 0)
         {
            param1.removeChildAt(0);
         }
      }
      
      public static function disposeObject(param1:Object) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Bitmap = null;
         var _loc4_:BitmapData = null;
         var _loc5_:DisplayObject = null;
         if(param1 == null)
         {
            return;
         }
         if(param1 is Disposeable)
         {
            if(param1 is DisplayObject)
            {
               _loc2_ = param1 as DisplayObject;
               if(_loc2_.parent)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
            }
            Disposeable(param1).dispose();
         }
         else if(param1 is Bitmap)
         {
            _loc3_ = Bitmap(param1);
            if(_loc3_.parent)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
            _loc3_.bitmapData.dispose();
         }
         else if(param1 is BitmapData)
         {
            _loc4_ = BitmapData(param1);
            _loc4_.dispose();
         }
         else if(param1 is DisplayObject)
         {
            _loc5_ = DisplayObject(param1);
            if(_loc5_.parent)
            {
               _loc5_.parent.removeChild(_loc5_);
            }
         }
      }
      
      private static function getCopyAbleType() : Vector.<String>
      {
         if(_copyAbleTypes == null)
         {
            _copyAbleTypes = new Vector.<String>();
            _copyAbleTypes.push("int");
            _copyAbleTypes.push("uint");
            _copyAbleTypes.push("String");
            _copyAbleTypes.push("Boolean");
            _copyAbleTypes.push("Number");
         }
         return _copyAbleTypes;
      }
      
      public static function describeTypeSave(param1:Object) : XML
      {
         var _loc2_:XML = null;
         var _loc3_:String = getQualifiedClassName(param1);
         if(_descriptOjbXMLs[_loc3_] != null)
         {
            _loc2_ = _descriptOjbXMLs[_loc3_];
         }
         else
         {
            _loc2_ = describeType(param1);
            _descriptOjbXMLs[_loc3_] = _loc2_;
         }
         return _loc2_;
      }
      
      public static function encode(param1:String, param2:Object) : XML
      {
         var value:Object = null;
         var key:String = null;
         var v:XML = null;
         var node:String = param1;
         var object:Object = param2;
         var temp:String = "<" + node + " ";
         var classInfo:XML = describeTypeSave(object);
         if(classInfo.@name.toString() == "Object")
         {
            for(key in object)
            {
               value = object[key];
               if(!(value is Function))
               {
                  temp += encodingProperty(key,value);
               }
            }
         }
         else
         {
            for each(v in classInfo..*.(name() == "variable" || name() == "accessor"))
            {
               temp += encodingProperty(v.@name.toString(),object[v.@name]);
            }
         }
         temp += "/>";
         return new XML(temp);
      }
      
      private static function encodingProperty(param1:String, param2:Object) : String
      {
         if(param2 is Array)
         {
            return "";
         }
         return escapeString(param1) + "=\"" + String(param2) + "\" ";
      }
      
      private static function escapeString(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:String = "";
         var _loc4_:Number = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param1.charAt(_loc5_);
            switch(_loc3_)
            {
               case "\"":
                  _loc2_ += "\\\"";
                  break;
               case "/":
                  _loc2_ += "\\/";
                  break;
               case "\\":
                  _loc2_ += "\\\\";
                  break;
               case "\b":
                  _loc2_ += "\\b";
                  break;
               case "\f":
                  _loc2_ += "\\f";
                  break;
               case "\n":
                  _loc2_ += "\\n";
                  break;
               case "\r":
                  _loc2_ += "\\r";
                  break;
               case "\t":
                  _loc2_ += "\\t";
                  break;
               default:
                  if(_loc3_ < " ")
                  {
                     _loc6_ = _loc3_.charCodeAt(0).toString(16);
                     _loc7_ = _loc6_.length == 2 ? "00" : "000";
                     _loc2_ += "\\u" + _loc7_ + _loc6_;
                  }
                  else
                  {
                     _loc2_ += _loc3_;
                  }
                  break;
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      public static function modifyVisibility(param1:Boolean, ... rest) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < rest.length)
         {
            (rest[_loc3_] as DisplayObject).visible = param1;
            _loc3_++;
         }
      }
      
      public static function copyPropertyByRectangle(param1:DisplayObject, param2:Rectangle) : void
      {
         param1.x = param2.x;
         param1.y = param2.y;
         if(param2.width != 0)
         {
            param1.width = param2.width;
         }
         if(param2.height != 0)
         {
            param1.height = param2.height;
         }
      }
      
      public static function combineXML(param1:XML, param2:XML) : void
      {
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(param2 == null || param1 == null)
         {
            return;
         }
         var _loc3_:XMLList = param2.attributes();
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.name().toString();
            _loc6_ = _loc4_.toString();
            if(!param1.hasOwnProperty("@" + _loc5_))
            {
               param1["@" + _loc5_] = _loc6_;
            }
         }
      }
   }
}
