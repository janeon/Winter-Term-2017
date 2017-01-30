// Jane Hsieh
// January 4 - 11

import UIKit

struct Manipulate {
    var Image: RGBAImage
    func convert () -> RGBAImage {
        return Image
    }
    
    func posterize(Intensity: Int) -> RGBAImage {
        let posterizeAmount = Intensity
        var posterized = Image
        for y in 0..<self.Image.height {
            for x in 0..<self.Image.width {
                let index = y * self.Image.width + x
                var pixel = self.Image.pixels[index]
                pixel.red = UInt8(Int(pixel.red) - Int(pixel.red)%posterizeAmount)
                pixel.green = UInt8(Int(pixel.green) - Int(pixel.green)%posterizeAmount)
                pixel.blue = UInt8(Int(pixel.blue) - Int(pixel.blue)%posterizeAmount)
                posterized.pixels[index] = pixel
            }
        }
        return posterized
    }

    func fade(Intensity: Int) -> RGBAImage {
        let fadeAmount = Intensity/3
        var faded = Image
        for y in 0..<self.Image.height/2 {
            for x in 0..<self.Image.width {
                let index = y * self.Image.width + x
                var pixel = self.Image.pixels[index]
                pixel.red = UInt8 (max(0,min(255,Int(pixel.red) + fadeAmount*(1+self.Image.height/2-y))))
                pixel.green = UInt8(max(0,min(255,Int(pixel.green) + fadeAmount*(1+self.Image.height/2-y))))
                pixel.blue = UInt8(max(0,min(255,Int(pixel.blue) + fadeAmount*(self.Image.height/2-y+1))))
                faded.pixels[index] = pixel
            }}
        for y in 0..<self.Image.height/2 {
            for x in 0..<self.Image.width {
                let index = y * self.Image.width + x + self.Image.width * self.Image.height/2
                var pixel = self.Image.pixels[index]
                pixel.red = UInt8 (max(0,min(255,Int(pixel.red) + fadeAmount*(y+1))))
                pixel.green = UInt8(max(0,min(255,Int(pixel.green) + fadeAmount*(y+1))))
                pixel.blue = UInt8(max(0,min(255,Int(pixel.blue) + fadeAmount*(y+1))))
                faded.pixels[index] = pixel
            }
        }
        return faded
    }
    
    func contrast(Intensity:Int) -> RGBAImage {
        let contrastAmount = Intensity
        var contrast = Image
        for y in 0..<self.Image.height {
            for x in 0..<self.Image.width {
                let index = y * self.Image.width + x
                var pixel = self.Image.pixels[index]
                let redDiff = Int(pixel.red) - 128
                let greenDiff = Int(pixel.green) - 128
                let blueDiff = Int(pixel.blue) - 128
                pixel.red = UInt8( max(0,min(255,255+redDiff*contrastAmount)))
                pixel.green = UInt8( max(0,min(255,255+greenDiff*contrastAmount)))
                pixel.blue = UInt8( max(0,min(255,255+blueDiff*contrastAmount)))
                contrast.pixels[index] = pixel
            }
        }
        return contrast
    }
    
    func brighten(Intensity:Int) -> RGBAImage {
        let brightenAmount = Intensity
        var brighten = Image
        for y in 0..<self.Image.height {
            for x in 0..<self.Image.width {
                let index = y * self.Image.width + x
                var pixel = self.Image.pixels[index]
                pixel.red = UInt8( max(0,min(255,Int(pixel.red)+brightenAmount*7/3)))
                pixel.green = UInt8( max(0,min(255,Int(pixel.green)+brightenAmount*7/3)))
                pixel.blue = UInt8( max(0,min(255,Int(pixel.blue)+brightenAmount*7/3)))
                brighten.pixels[index] = pixel
            }
        }
        return brighten
    }
    
    func darken(Intensity:Int) -> RGBAImage {
        let darkenAmount = Intensity
        var darken = Image
        for y in 0..<self.Image.height {
            for x in 0..<self.Image.width {
                let index = y * self.Image.width + x
                var pixel = self.Image.pixels[index]
                pixel.red = UInt8( max(0,min(255,Int(pixel.red)-darkenAmount*11/5)))
                pixel.green = UInt8( max(0,min(255,Int(pixel.green)-darkenAmount*11/5)))
                pixel.blue = UInt8( max(0,min(255,Int(pixel.blue)-darkenAmount*11/5)))
                darken.pixels[index] = pixel
            }
        }
        return darken
    }
}
// this struct applies filters to an UIImage and returns the filtered UI
struct filters {
    var ImageUI: UIImage
    func process(Intensity:Int,process:String) -> UIImage {
        let Image = RGBAImage(image: ImageUI)!
        let pic = Manipulate(Image: Image)
        var picRGBA = Image
        
        if process == "P" {
            picRGBA = pic.posterize(Intensity)
        }
        else if process == "F" {
            picRGBA = pic.fade(Intensity)
        }
        else if process == "C" {
                picRGBA = pic.contrast(Intensity)
        }
        else if process == "B" {
            picRGBA = pic.brighten(Intensity)
        }
        else if process == "D" {
            picRGBA = pic.darken(Intensity)
        }
        else if process == "N" {
            picRGBA = Image
        }
        return picRGBA.toUIImage()!
    }
}

func Processor(UI:UIImage,process:String,Intensity:Int) -> UIImage {
//    let uiimage = UIImage(named:name)!
    let original = filters(ImageUI: UI)
    let filtered = original.process(Intensity, process: process)
    return filtered
}

func filter (commandlist:[String],filename:String) -> UIImage {
    let ui = UIImage(named: filename)!
    var image = ui
    for str in commandlist {
        if str.characters.count==1 {
            var Intensity = 0
            if str == "P"{
                Intensity = 32
            }
            else if str == "C"{
                Intensity = 5
            }
            else if str == "B"{
                Intensity = 5
            }
            else if str == "D"{
                Intensity = 15
            }
            else if str == "F"{
                Intensity = 2
            }
            image = Processor(image,process:str,Intensity: Intensity)
        }
        else {
        let command = String(str[str.startIndex])
        let Intensity = Int(str[str.startIndex.advancedBy(1)..<str.startIndex.advancedBy(str.characters.count)])!
        image = Processor(image,process: command,Intensity: Intensity)
        }
    }
    return image
}

func Default(command:String,filename:String) -> UIImage {
    let ui = UIImage(named: filename)!
    var Intensity = 0
    if command == "P"{
        Intensity = 32
    }
    else if command == "C"{
        Intensity = 5
    }
    else if command == "B"{
        Intensity = 5
    }
    else if command == "D"{
        Intensity = 15
    }
    else if command == "F"{
        Intensity = 20
    }
    return Processor(ui,process:command,Intensity:Intensity)
    
}
/* 
  Hello classmate! I have for you five filters to choose from, they are called:
  
  P: Posterize
  C: Contrast
  B: Brighten
  D: Darken
  F: Fade
  
  To access one or more of these filters, make a call to the function "filter", and enter the follwing parameters:
  1.) The command(s) in an stringed array. Your strings should contain the first letter of the filter name, followed by intensity (ranging usually from 1-100).
  2.) The filename as a string.
  
  Uncomment line below to access example filter call */
 
//  filter(["D13","P49"], filename: "sample")
 /*
  To access any of my default filters, make a call to Default, and enter similar parameters:
  1.) The single letter command as a string.
  2.) The filename as a string.*/
 
//  Default("F", filename: "sample")
 
 
 /* Congratulations on finishing the course, and thanks for grading :) */
