[#ftl]
[#--template for the client-side complex/simple type interface.--]
// Generated by xsd compiler for ios/objective-c
// DO NOT CHANGE!

#import <Foundation/Foundation.h>
#import "${projectPrefix}${clazz.name}.h"
#import "${projectPrefix}Object.h"
#import "${projectPrefix}DateFormatterUtils.h"
[#list fieldClassImports as import]
#import "${import}.h"
[/#list]

@interface ${projectPrefix}${clazz.name} ()
[#list clazz.fields as field]
[#if field.fixedValue]
    [#if field.type.collection]
        [#assign type = field.type.typeParameters?first]
        [#assign fieldType = "NSMutableArray/*"]
        [#if !type.primitive]
            [#assign fieldType = "${fieldType}${projectPrefix}"]
        [/#if]
        [#assign fieldType = "${fieldType}${type.fullName}*/"]
    [#elseif field.type.enum]
            [#assign fieldType = "${projectPrefix}${field.type.fullName}"]
    [#elseif field.propertyKindAny]
            [#assign fieldType = "NSMutableArray"]
    [#else]
        [#if field.type.primitive]
                [#assign fieldType = "${field.type.fullName}"]
        [#else]
            [#assign fieldType = "${projectPrefix}${field.type.fullName}"]
        [/#if]
    [/#if]
    @property (nonatomic, strong) ${fieldType} *${field.name};
[/#if]
[/#list]
@end

@implementation ${projectPrefix}${clazz.name}

- (id)init {
    self = [super init];
    if (self) {
    [#list clazz.fields as field]
    [#if field.value??]
    [#if field.type.enum]
        self.${field.name} = ${field.type.fullName?upper_case}_${field.value};
    [#elseif field.type.primitive]
        [#if field.type.name == "DATE"]
            self.${field.name} = [${projectPrefix}DateFormatterUtils convertToDate:dict${"["}@"${field.initialName}"]];
        [#elseif field.type.name == "STRING"]
            self.${field.name} = @"${field.value}";
        [#else]
            self.${field.name} = ${field.value};
        [/#if]
    [#else]
        //self.${field.name} = ${field.value};
    [/#if]
    [/#if]
    [/#list]
    }
    return self;
}

[#assign fieldIndex = 0]
[#assign values = ""]
[#list clazz.fields as field]
    [#if !field.value??]
        [#if fieldIndex == 0]
            [#assign values = "${values}${field.name?cap_first}"]
        [#else]
            [#assign values = "${values} ${field.name}"]
        [/#if]
        [#assign values = "${values}: ("]
        [#if field.type.collection]
            [#assign values = "${values}NSMutableArray/*${projectPrefix}${field.type.typeParameters[0].fullName}*/"]
        [#elseif field.type.enum]
            [#assign values = "${values}${projectPrefix}${field.type.fullName}"]
        [#elseif field.propertyKindAny]
            [#assign values = "${values}NSMutableArray"]
        [#elseif field.type.primitive]
            [#assign values = "${values}${field.type.fullName}"]
        [#else]
            [#assign values = "${values}${projectPrefix}${field.type.fullName}"]
        [/#if]
        [#if field.type.wrapper.pointer]
            [#assign values = "${values}*"]
        [/#if]
        [#assign values = "${values}) ${field.name}Param"]
        [#assign fieldIndex = fieldIndex + 1]
    [/#if]
[/#list]
-(id) initWithValues${values}
{
    self = [self init];
    if(self) {
    [#list clazz.fields as field]
    [#if !field.value??]
        self.${field.name} = ${field.name}Param;
    [/#if]
    [/#list]
    }
    return self;
}

-(id) initWithDictionnary:(NSDictionary*)dict
{
    self = [#if clazz.superClass??][super initWithDictionnary:dict][#else][super init][/#if];
    if(self) {
    [#list clazz.fields as field]
        if (dict${"[@"}"${field.name}"] != [NSNull null])
        {
            [#if field.type.enum]
            self.${field.name} = [${projectPrefix}${field.type.fullName} fromString:dict${"["}@"${field.initialName}"]];
            [#elseif field.type.collection || field.type.array]
            id ${field.name}_dict = dict${"["}@"${field.initialName}"];

            NSMutableArray * ${field.name}Array = [[NSMutableArray alloc] initWithCapacity:[(NSArray*)${field.name}_dict count]];

            if([(NSArray*)${field.name}_dict count] > 0) {
                [#assign typeParameter = field.type.typeParameters?first]

                [#if typeParameter.enum]
                for (NSString * dictValue in (NSArray*)${field.name}_dict) {
                ${projectPrefix}${typeParameter.fullName} * d = [${projectPrefix}${typeParameter.fullName} fromString:dictValue];
                [#elseif typeParameter.primitive]
                for (${typeParameter.fullName}* dictValue in (NSArray*)${field.name}_dict) {
                ${typeParameter.fullName} * d = dictValue;
                [#else]
                for (NSDictionary* dict in (NSArray*)${field.name}_dict) {
                ${projectPrefix}${typeParameter.fullName} * d = [[${projectPrefix}${typeParameter.fullName} alloc]initWithDictionnary:dict];
                [/#if]

                [${field.name}Array addObject:d];
                }
                self.${field.name} = ${field.name}Array;
                }
            [#elseif field.type.primitive]
                [#if field.type.wrapper == "NSDATE"]
                    self.${field.name} = [${projectPrefix}DateFormatterUtils convertToDate:dict${"["}@"${field.initialName}"]];
                [#elseif field.type.wrapper == "BOOL"]
                    self.${field.name} = [((NSNumber *)dict${"["}@"${field.initialName}"]) boolValue];
                [#elseif field.type.wrapper == "NSINTEGER"]
                    self.${field.name} = [((NSNumber *)dict${"["}@"${field.initialName}"]) integerValue];
                [#elseif field.type.wrapper == "FLOAT"]
                    self.${field.name} = [((NSNumber *)dict${"["}@"${field.initialName}"]) floatValue];
                [#elseif field.type.wrapper == "DOUBLE"]
                    self.${field.name} = [((NSNumber *)dict${"["}@"${field.initialName}"]) doubleValue];
                [#elseif field.type.wrapper == "LONG"]
                    self.${field.name} = [((NSNumber *)dict${"["}@"${field.initialName}"]) longValue];
                [#else]
                    self.${field.name} = dict${"["}@"${field.initialName}"];
                [/#if]
            [#else]
                NSDictionary * ${field.name}_dict = dict${"["}@"${field.initialName}"];
                if(${field.name}_dict != nil) {
                    self.${field.name} = [[${projectPrefix}${field.type.fullName} alloc]initWithDictionnary:${field.name}_dict];
                }
            [/#if]
        }
    [/#list]
    }
    return self;
}

-(NSDictionary*) asDictionary {
    NSMutableDictionary* dict = [#if clazz.superClass??][[NSMutableDictionary alloc] initWithDictionary:[super asDictionary]][#else][[NSMutableDictionary alloc] init][/#if];

[#list clazz.fields as field]

[#if field.type.enum]
    if(self.${field.name} != nil) {
        dict${"["}@"${field.initialName}"] = self.${field.name}.value;
    }
[#elseif field.type.primitive || field.propertyKindAny]
    [#if field.type.wrapper.pointer]if(self.${field.name} != nil) {[/#if]
        [#if field.type.wrapper == "NSDATE"]
            dict${"["}@"${field.initialName}"] = [${projectPrefix}DateFormatterUtils formatWithDate:self.${field.name}];
        [#elseif field.type.wrapper == "BOOL"]
            dict${"["}@"${field.initialName}"] = [NSNumber numberWithBool:self.${field.name}];
        [#elseif field.type.wrapper == "NSINTEGER"]
            dict${"["}@"${field.initialName}"] = [NSNumber numberWithInteger:self.${field.name}];
        [#elseif field.type.wrapper == "FLOAT"]
            dict${"["}@"${field.initialName}"] = [NSNumber numberWithFloat:self.${field.name}];
        [#elseif field.type.wrapper == "DOUBLE"]
            dict${"["}@"${field.initialName}"] = [NSNumber numberWithDouble:self.${field.name}];
        [#elseif field.type.wrapper == "LONG"]
            dict${"["}@"${field.initialName}"] = [NSNumber numberWithLong:self.${field.name}];
        [#else]
            dict${"["}@"${field.initialName}"] = self.${field.name};
        [/#if]
    [#if field.type.wrapper.pointer]}[/#if]
[#elseif field.type.array || field.type.collection]
    [#assign typeParameter = field.type.typeParameters?first]
    if(self.${field.name} != nil){
        NSMutableArray * array = [[NSMutableArray alloc] init];
        [#if typeParameter.enum]
            for( ${projectPrefix}${typeParameter.fullName} *${field.name}Element in self.${field.name}) {
            [array addObject:${field.name}Element.value];
        [#elseif typeParameter.primitive]
            for( ${typeParameter.fullName} *${field.name}Element in self.${field.name}) {
            [array addObject:${field.name}Element];
        [#else]
            for( ${projectPrefix}${typeParameter.fullName} *${field.name}Element in self.${field.name}) {
            [array addObject:[${field.name}Element asDictionary]];
        [/#if]
        }
        dict${"["}@"${field.initialName}"] = array;
    }
[#else]
    if(self.${field.name} != nil) {
        dict${"["}@"${field.initialName}"] = [self.${field.name} asDictionary];
    }
[/#if]
[/#list]
    return dict;
}
@end
