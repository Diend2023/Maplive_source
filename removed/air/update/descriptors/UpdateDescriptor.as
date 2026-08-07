package air.update.descriptors
{
   import air.update.utils.Constants;
   
   public class UpdateDescriptor
   {
      
      public static const NAMESPACE_UPDATE_1_0:Namespace = new Namespace("http://ns.adobe.com/air/framework/update/description/1.0");
      
      public static const NAMESPACE_UPDATE_2_5:Namespace = new Namespace("http://ns.adobe.com/air/framework/update/description/2.5");
      
      private var defaultNS:Namespace;
      
      private var xml:XML;
      
      public function UpdateDescriptor(param1:XML)
      {
         super();
         this.xml = param1;
         this.defaultNS = param1.namespace();
      }
      
      private static function validateLocalizedText(param1:XMLList, param2:Namespace) : Boolean
      {
         var _loc5_:XML = null;
         default xml namespace = param2;
         var _loc3_:Namespace = new Namespace("http://www.w3.org/XML/1998/namespace");
         if(param1.hasSimpleContent())
         {
            return true;
         }
         if(param1.length() > 1)
         {
            return false;
         }
         var _loc4_:XMLList = param1.*;
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.name() == null)
            {
               return false;
            }
            if(_loc5_.name().localName != "text")
            {
               return false;
            }
            if(_loc5_._loc3_::@lang.length() == 0)
            {
               return false;
            }
            if(!_loc5_.hasSimpleContent())
            {
               return false;
            }
         }
         return true;
      }
      
      public static function getLocalizedText(param1:XMLList, param2:Namespace) : Array
      {
         var _loc5_:XMLList = null;
         var _loc6_:XML = null;
         default xml namespace = param2;
         var _loc3_:Namespace = new Namespace("http://www.w3.org/XML/1998/namespace");
         var _loc4_:Array = [];
         if(param1.hasSimpleContent())
         {
            _loc4_ = [["",param1.toString()]];
         }
         else
         {
            _loc5_ = param1.param2::text;
            for each(_loc6_ in _loc5_)
            {
               _loc4_.push([_loc6_._loc3_::@lang.toString(),_loc6_[0].toString()]);
            }
         }
         return _loc4_;
      }
      
      public static function isKnownVersion(param1:Namespace) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         switch(param1.uri)
         {
            case NAMESPACE_UPDATE_1_0.uri:
            case NAMESPACE_UPDATE_2_5.uri:
               return true;
            default:
               return false;
         }
      }
      
      public function getXML() : XML
      {
         default xml namespace = this.defaultNS;
         return this.xml;
      }
      
      public function get versionLabel() : String
      {
         default xml namespace = this.defaultNS;
         if(this.xml.version != undefined)
         {
            return this.xml.version.toString();
         }
         return this.xml.versionLabel != undefined ? this.xml.versionLabel.toString() : this.xml.versionNumber.toString();
      }
      
      public function get version() : String
      {
         default xml namespace = this.defaultNS;
         return this.xml.version != undefined ? this.xml.version.toString() : this.xml.versionNumber.toString();
      }
      
      public function get description() : Array
      {
         default xml namespace = this.defaultNS;
         return UpdateDescriptor.getLocalizedText(this.xml.description,this.defaultNS);
      }
      
      public function isCompatibleWithApplicationDescriptor(param1:Boolean) : Boolean
      {
         default xml namespace = this.defaultNS;
         var _loc2_:* = this.xml.versionNumber != undefined;
         return _loc2_ == param1;
      }
      
      public function validate() : void
      {
         default xml namespace = this.defaultNS;
         if(!isKnownVersion(this.defaultNS))
         {
            throw new Error("unknown update descriptor namespace",Constants.ERROR_UPDATE_UNKNOWN);
         }
         if(this.xml.versionNumber != undefined)
         {
            if(this.version == "")
            {
               throw new Error("update versionNumber must have a non-empty value",Constants.ERROR_VERSION_MISSING);
            }
            if(!/^[0-9]{1,3}(\.[0-9]{1,3}){0,2}$/.test(this.version))
            {
               throw new Error("update versionNumber contains an invalid value",Constants.ERROR_VERSION_INVALID);
            }
         }
         else if(this.version == "")
         {
            throw new Error("update version must have a non-empty value",Constants.ERROR_VERSION_MISSING);
         }
         if(this.url == "")
         {
            throw new Error("update url must have a non-empty value",Constants.ERROR_URL_MISSING);
         }
         if(!validateLocalizedText(this.xml.description,this.defaultNS))
         {
            throw new Error("Illegal values for update/description",Constants.ERROR_DESCRIPTION_INVALID);
         }
      }
      
      public function get url() : String
      {
         default xml namespace = this.defaultNS;
         return this.xml.url.toString();
      }
   }
}

