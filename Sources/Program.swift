import Foundation

import ArgumentParser
import PDFKit


func printMessage(_ message: String) {
    let stderr = FileHandle.standardError

    if let data = message.data(using: .utf8) {
        stderr.write(data)
    }
}

func mergePDFs(inputPaths: [String], outputPath: String) throws {
    // Create a new PDFDocument to hold the merged PDFs
    let mergedPDF = PDFDocument()

    // Iterate over the inputPaths array and add each PDF file to the mergedPDF document
    for (index, path) in inputPaths.enumerated() {
        print("[\(index+1)/\(inputPaths.count)]: adding \(path)")

        if let pdf = PDFDocument(url: URL(fileURLWithPath: path)) {
            for i in 0..<pdf.pageCount {
                if let page = pdf.page(at: i) {
                    mergedPDF.insert(page, at: mergedPDF.pageCount)
                }
            }
        } else {
            throw NSError(domain: "com.example.pdfkit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to add file \"\(path)\""])
        }
    }

    // Write the merged PDF document to the output path
    mergedPDF.write(toFile: outputPath)

    print("Success: \(outputPath) created.")
}

@main
struct Program: ParsableCommand {
    @Argument(help: "Input files")
    var inputFiles: [String]

    @Option(name: .shortAndLong, help: "Output file")
    var outputFile: String = "merged.pdf"

    func run() throws {
        try mergePDFs(inputPaths: inputFiles, outputPath: outputFile)
    }
}
