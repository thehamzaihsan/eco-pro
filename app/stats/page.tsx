import Image from "next/image"
import Link from "next/link"
import { ArrowLeft } from "lucide-react"

export default function StatsPage() {
  const stats = [
    {
      title: "Confusion Matrix",
      description: "Shows the performance of the classification model across all categories",
      image: "/stats/confusion_matrix.png",
    },
    {
      title: "Normalized Confusion Matrix",
      description: "Normalized view of classification performance for better comparison",
      image: "/stats/confusion_matrix_normalized.png",
    },
    {
      title: "Metrics Comparison",
      description: "Comparative view of precision, recall, and F1-score across categories",
      image: "/stats/metrics_comparison.png",
    },
    {
      title: "Precision Score",
      description: "Measures the accuracy of positive predictions for each category",
      image: "/stats/precision_plot.png",
    },
    {
      title: "Recall Score",
      description: "Measures the ability to find all positive instances",
      image: "/stats/recall_plot.png",
    },
    {
      title: "F1 Score",
      description: "Harmonic mean of precision and recall for balanced performance metric",
      image: "/stats/f1_score_plot.png",
    },
    {
      title: "Specificity Score",
      description: "Measures the ability to identify negative instances correctly",
      image: "/stats/specificity_plot.png",
    },
  ]

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="sticky top-0 z-10 border-b border-border bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center gap-4">
            <Link
              href="/"
              className="flex items-center gap-2 text-sm font-medium text-muted-foreground hover:text-foreground transition-colors"
            >
              <ArrowLeft className="w-4 h-4" />
              Back to Home
            </Link>
          </div>
          <div className="mt-4">
            <h1 className="text-3xl font-bold tracking-tight">Model Performance Statistics</h1>
            <p className="text-muted-foreground mt-2">
              Detailed analytics and performance metrics of the waste classification model
            </p>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {stats.map((stat, index) => (
            <div
              key={index}
              className="group relative overflow-hidden rounded-xl border border-border bg-card transition-all hover:shadow-lg hover:border-primary/50"
            >
              <div className="p-6">
                <h2 className="text-xl font-semibold mb-2 group-hover:text-primary transition-colors">
                  {stat.title}
                </h2>
                <p className="text-sm text-muted-foreground mb-4">{stat.description}</p>
              </div>
              
              <div className="relative aspect-[4/3] bg-muted overflow-hidden">
                <Image
                  src={stat.image}
                  alt={stat.title}
                  fill
                  className="object-contain p-4 transition-transform group-hover:scale-105"
                  sizes="(max-width: 1024px) 100vw, 50vw"
                />
              </div>
            </div>
          ))}
        </div>

        {/* Summary Section */}
        <div className="mt-12 rounded-xl border border-border bg-card p-8">
          <h2 className="text-2xl font-bold mb-4">About These Metrics</h2>
          <div className="grid md:grid-cols-2 gap-6 text-sm text-muted-foreground">
            <div>
              <h3 className="font-semibold text-foreground mb-2">Confusion Matrix</h3>
              <p>
                Visualizes the performance of the classification algorithm by comparing predicted vs actual
                classifications. Darker colors indicate higher values.
              </p>
            </div>
            <div>
              <h3 className="font-semibold text-foreground mb-2">Precision & Recall</h3>
              <p>
                Precision measures accuracy of positive predictions, while recall measures the ability to find
                all positive instances. Both are crucial for model evaluation.
              </p>
            </div>
            <div>
              <h3 className="font-semibold text-foreground mb-2">F1 Score</h3>
              <p>
                The harmonic mean of precision and recall, providing a single metric that balances both
                concerns. Higher F1 scores indicate better overall performance.
              </p>
            </div>
            <div>
              <h3 className="font-semibold text-foreground mb-2">Specificity</h3>
              <p>
                Measures how well the model identifies negative instances. Important for avoiding
                false positives in waste classification.
              </p>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}
