export type TrashCategory = "paper" | "cardboard" | "plastic" | "vegetation" | "biological" | "metal" | "clothes" | "glass" | "trash" | "shoes" | "battery" | "others"

export const categoryConfig: Record<
  TrashCategory,
  {
    label: string
    color: string
    icon: string
    position: number
  }
> = {
  paper: {
    label: "paper",
    color: "#e8e8e8",
    icon: "📄",
    position: 9,
  },
  cardboard: {
    label: "cardboard",
    color: "#c9b458",
    icon: "📦",
    position: 18,
  },
  plastic: {
    label: "plastic",
    color: "#5b9bd5",
    icon: "🥤",
    position: 27,
  },
  vegetation: {
    label: "vegetation",
    color: "#7cb342",
    icon: "🌿",
    position: 36,
  },
  biological: {
    label: "biological",
    color: "#8d6e63",
    icon: "🍂",
    position: 45,
  },
  metal: {
    label: "metal",
    color: "#9e9e9e",
    icon: "🔩",
    position: 54,
  },
  clothes: {
    label: "clothes",
    color: "#ab47bc",
    icon: "👕",
    position: 63,
  },
  glass: {
    label: "glass",
    color: "#45b7d1",
    icon: "🍾",
    position: 72,
  },
  trash: {
    label: "trash",
    color: "#424242",
    icon: "🗑️",
    position: 81,
  },
  shoes: {
    label: "shoes",
    color: "#6d4c41",
    icon: "👟",
    position: 90,
  },
  battery: {
    label: "battery",
    color: "#ffd54f",
    icon: "🔋",
    position: 100,
  },
  others: {
    label: "others",
    color: "#ff9800",
    icon: "❓",
    position: 110,
  },
}

const categories: TrashCategory[] = ["paper", "cardboard", "plastic", "vegetation", "biological", "metal", "clothes", "glass", "trash", "shoes", "battery", "others"]

export async function classifyTrash(imageUrl: string, modelKey?: string): Promise<{ category: TrashCategory }> {
  try {
    // Convert base64 data URL to File object
    const response = await fetch(imageUrl)
    const blob = await response.blob()
    const file = new File([blob], "image.jpg", { type: blob.type })

    // Create FormData and append the image
    const formData = new FormData()
    formData.append("image", file)
    if (modelKey) {
      formData.append("model", modelKey)
    }

    // Call Next.js API route (which proxies to Python backend)
    const apiResponse = await fetch("/api/classify", {
      method: "POST",
      body: formData,
    })

    if (!apiResponse.ok) {
      throw new Error(`API error: ${apiResponse.status}`)
    }

    const data = await apiResponse.json()
    
    // Get the first prediction's class_name and confidence
    let category: TrashCategory
    if (data.predictions && data.predictions.length > 0) {
      const topPrediction = data.predictions[0]
      const className = topPrediction.class_name?.toLowerCase().trim()
      const topConfidence = topPrediction.confidence || 0
      
      // Check if confidence is below 0.80 threshold
      if (topConfidence < 0.80) {
        category = 'others'
      } else {
        // Check difference from second highest class (if available)
        let differenceFromSecond = 1.0 // Default to max difference if only one prediction
        if (data.predictions.length > 1) {
          const secondConfidence = data.predictions[1].confidence || 0
          differenceFromSecond = topConfidence - secondConfidence
        }
        
        // Require difference > 0.80 from other classes
        if (differenceFromSecond <= 0.80) {
          category = 'others'
        } else {
          // Create mapping for variations
          const classNameMap: Record<string, TrashCategory> = {
            'paper': 'paper',
            'cardboard': 'cardboard',
            'plastic': 'plastic',
            'vegetation': 'vegetation',
            'biological': 'biological',
            'metal': 'metal',
            'clothes': 'clothes',
            'glass': 'glass',
            'miscellaneous trash': 'trash',
            'miscellaneous': 'trash',
            'trash': 'trash',
            'shoes': 'shoes',
            'battery': 'battery',
          }
          
          // Map class name to our category
          if (classNameMap[className]) {
            category = classNameMap[className]
          } else {
            // Fallback to others if invalid category
            console.warn("Invalid category received:", className)
            category = 'others'
          }
        }
      }
    } else {
      // Fallback to others if no predictions
      console.warn("No predictions received:", data)
      category = 'others'
    }
    
    return { category }
  } catch (error) {
    console.error("Classification error:", error)
    // Fallback to others category on error
    return { category: 'others' }
  }
}
